import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/screens/project_detail_page.dart';
import 'package:project_manager/screens/admin_panel.dart'; // Import the AdminPanel screen
import 'package:project_manager/services/auth.dart';
import 'package:project_manager/services/database.dart';
import 'package:project_manager/models/user.dart';

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
          FutureBuilder<String?>(
            future: _auth.getCurrentUserID(), // Fetch current user ID
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasData) {
                String userId = snapshot.data!; // Retrieve user ID
                return FutureBuilder<String?>(
                  future: _databaseService.getUserRole(userId), // Fetch user role
                  builder: (context, roleSnapshot) {
                    if (roleSnapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (roleSnapshot.hasData) {
                      String? userRole = roleSnapshot.data;
                      if (userRole == 'admin') {
                        return IconButton( // Add a button to navigate to the admin panel
                          icon: Icon(Icons.admin_panel_settings),
                          tooltip:'Moderator',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AdminPanel()), // Navigate to the AdminPanel screen
                            );
                          },
                        );
                      } else {
                        return Text('User role: $userRole'); // Display user role if not admin
                      }
                    } else {
                      return Text('Role data not available'); // Handle case when role data is not available
                    }
                  },
                );
              } else {
                return Text('No ID available'); // Display message if user ID is not available
              }
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
