// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/services/database.dart';

class AddProjectPage extends StatefulWidget {
  @override
  _AddProjectPageState createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final TextEditingController _nazivController = TextEditingController();
  final TextEditingController _adresaController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Project'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nazivController,
              decoration: InputDecoration(
                labelText: 'Project Name',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _adresaController,
              decoration: InputDecoration(
                labelText: 'Project Address',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _addProject();
              },
              child: Text('Add Project'),
            ),
          ],
        ),
      ),
    );
  }

  void _addProject() {
    String naziv = _nazivController.text.trim();
    String adresa = _adresaController.text.trim();
    String projectId = Project.generateUniqueId();



    if (naziv.isNotEmpty && adresa.isNotEmpty) {
      Project project = Project(naziv: naziv, adresa: adresa, id: projectId);
      _databaseService.addProject(project);
      Navigator.pop(context);
    } else {
      // Show error message if fields are empty
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please fill in all fields.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
