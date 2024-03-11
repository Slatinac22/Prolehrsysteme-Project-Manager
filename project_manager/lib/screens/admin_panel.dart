// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/screens/project_detail_page.dart';
import 'package:project_manager/screens/project_edit_page.dart';
import 'package:project_manager/screens/add_project_page.dart';
import 'package:project_manager/services/auth.dart';
import 'package:project_manager/services/database.dart';
import 'package:project_manager/shared/colors.dart';
import 'dart:async';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final AuthService _auth = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  TextEditingController _searchController = TextEditingController();
  List<Project> _projects = [];
  List<Project> _filteredProjects = [];
  late StreamSubscription<List<Project>> _projectsSubscription;

  @override
  void initState() {
    super.initState();
    _projectsSubscription = _databaseService.streamProjects().listen(
      (projects) {
        setState(() {
          _projects = projects;
          _filteredProjects = projects;
        });
      },
      onError: (error) {
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
    _projectsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


   return Scaffold(
  backgroundColor: Colors.white,


  body: Column(
    children: [
      Material(
        elevation: 10,
        child: AppBar(
          toolbarHeight: 60,
          backgroundColor: AppColors.secondaryColor,
          centerTitle: true,
          title: Padding(
            padding: EdgeInsets.only(right: 50), // Add left padding
            child: Center(
              child: Text(
                'Project Manager',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),








          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search projects...',
              hintStyle: TextStyle(fontSize: 16.0),
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            ),
            onChanged: _filterProjects,
          ),
        ),
      ),
      Expanded(
        child: ListView.builder(
          itemCount: _filteredProjects.length,
          itemBuilder: (context, index) {
            Project project = _filteredProjects[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              elevation: 5.0,
              child: ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        project.naziv,
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmationDialog(context, project.id);
                      },
                    ),
                  ],
                ),
                subtitle: Text(
                  project.adresa,
                  style: TextStyle(fontSize: 16.0),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProjectEditPage(project: project)),
                  );
                },
              ),
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
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                try {
                  await _databaseService.deleteProject(projectId);
                  Navigator.of(context).pop();
                } catch (e) {
                  print('Error deleting project: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
