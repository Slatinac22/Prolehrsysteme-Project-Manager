import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/screens/project_detail_page.dart';
import 'package:project_manager/screens/admin_panel.dart'; // Import the AdminPanel screen
import 'package:project_manager/services/auth.dart';
import 'package:project_manager/services/database.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: Text('Project Manager'),
        backgroundColor: Colors.purple[400],
        actions: <Widget>[
          ElevatedButton.icon(
            icon: Icon(Icons.person),
            label: Text('Logout'),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
          IconButton( // Add a button to navigate to the admin panel
            icon: Icon(Icons.admin_panel_settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminPanel()), // Navigate to the AdminPanel screen
              );
            },
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder<List<Project>>(
          stream: _databaseService.streamProjects(), // Listen for real-time updates
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
              return Text('No projects found');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Project project = snapshot.data![index];
                  return ListTile(
                    title: Text(project.naziv),
                    subtitle: Text(project.adresa),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProjectDetailPage(project: project)),
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}
