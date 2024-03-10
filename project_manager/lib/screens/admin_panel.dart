import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/screens/project_detail_page.dart';
import 'package:project_manager/screens/project_edit_page.dart';
import 'package:project_manager/services/auth.dart';
import 'package:project_manager/services/database.dart';
import 'package:project_manager/screens/admin_edit_project_page.dart';
import 'package:project_manager/screens/add_project_page.dart';
import 'dart:async';

import 'package:project_manager/shared/colors.dart';


class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final AuthService _auth = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  TextEditingController _searchController = TextEditingController();
  List<Project> _projects = []; // List to hold all projects
  List<Project> _filteredProjects = []; // List to hold filtered projects
  late StreamSubscription<List<Project>> _projectsSubscription; // Late initialization

  @override
  void initState() {
    super.initState();
_projectsSubscription = _databaseService.streamProjects().listen(
  (projects) {
    setState(() {
      _projects = projects;
      _filteredProjects = projects; // Initially set filtered projects to all projects
    });
  },
  onError: (error) {
    // Handle error
    print('Error in stream: $error');
  },
);

  }

void _filterProjects(String query) {
  setState(() {
    _filteredProjects = _projects.where((project) {
      final titleLower = project.naziv.toLowerCase();
      final queryLower = query.toLowerCase();
      return titleLower.contains(queryLower);
    }).toList();
  });
}

  @override
  void dispose() {
    _projectsSubscription.cancel(); // Dispose of the projects stream subscription
    super.dispose();
  }
  void _fetchProjects() async {
    _projectsSubscription = _databaseService.streamProjects().listen((projects) {
      setState(() {
        _projects = projects;
        _filteredProjects = projects; // Initially set filtered projects to all projects
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
         backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        title: Text('Admin Panel'),
         backgroundColor: AppColors.primaryColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
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
              onChanged: _filterProjects,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredProjects.length,
              itemBuilder: (context, index) {
                Project project = _filteredProjects[index];
                return ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(project.naziv),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, project.id);
                        },
                      ),
                    ],
                  ),
                  subtitle: Text(project.adresa),
                  
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminProjectDetailPage(project: project)),
                    );
                  },
                  onLongPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProjectEditPage(project: project)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProjectPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, String projectId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this project?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                try {
                  // Perform the deletion operation
                  await _databaseService.deleteProject(projectId);
                  // Update UI after successful deletion
                  Navigator.of(context).pop();
                } catch (e) {
                  print('Error deleting project: $e');
                  // Handle error if deletion fails
                  // Optionally, you can show an error message to the user
                }
              },
            ),
          ],
        );
      },
    );
  }
}
