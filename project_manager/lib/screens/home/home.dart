import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/screens/project_detail_page.dart';
import 'package:project_manager/screens/admin_panel.dart';
import 'package:project_manager/services/auth.dart';
import 'package:project_manager/services/database.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/shared/colors.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  TextEditingController _searchController = TextEditingController();
  List<Project> _projects = []; // List to hold all projects
  List<Project> _filteredProjects = []; // List to hold filtered projects

  @override
  void initState() {
    super.initState();
    _fetchProjects(); // Fetch all projects when the widget initializes
  }

  void _fetchProjects() async {
    List<Project> projects = await _databaseService.fetchProjects();
    setState(() {
      _projects = projects;
      _filteredProjects = _filterProjects(projects, _searchController.text);
    });
  }

  List<Project> _filterProjects(List<Project> projects, String query) {
    return projects.where((project) {
      final titleLower = project.naziv.toLowerCase();
      final queryLower = query.toLowerCase();
      return titleLower.contains(queryLower);
    }).toList();
  }

  void _searchProjects(String query) {
    setState(() {
      _filteredProjects = _filterProjects(_projects, query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        title: Text('Project Manager'),
        backgroundColor: AppColors.primaryColor,
        actions: <Widget>[
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
                      if (userRole == 'admin' || userRole == 'moderator') {
                        return ElevatedButton( // ElevatedButton for Administrator
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AdminPanel()), // Navigate to the AdminPanel screen
                            );
                            _fetchProjects(); // Fetch projects again after returning from admin panel
                          },
                          child: Row( // Row to contain icon and text
                            children: [
                              Icon(
                                Icons.admin_panel_settings,
                                color: Colors.black, // Set color of the icon to blue
                                size: 32, // Set the size of the icon (adjust as needed)
                              ), // Icon for Administrator
                              SizedBox(width: 8), // Add some space between icon and text
                              Text(
                                'Administrator',
                                style: TextStyle(color: Colors.black,fontSize: 20), // Set color of the text to blue
                              ), // Text for Administrator
                            ],
                          ),
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
          SizedBox(width: 12),
          ElevatedButton.icon(
            icon: Icon(Icons.logout_rounded, color: Colors.black),
            label: Text('Odjavi se', style: TextStyle(color: Colors.black, fontSize: 20),),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search projects...',
              ),
              onChanged: _searchProjects,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredProjects.length,
              itemBuilder: (context, index) {
                Project project = _filteredProjects[index];
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
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}
