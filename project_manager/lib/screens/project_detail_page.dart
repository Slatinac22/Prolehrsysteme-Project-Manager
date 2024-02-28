import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/screens/project_edit_page.dart';
import 'package:project_manager/services/database.dart'; 

// Import the DatabaseService

class ProjectDetailPage extends StatelessWidget {
  final Project project;

  ProjectDetailPage({required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.naziv),
      ),
      body: Center(
        child: StreamBuilder(
          stream: DatabaseService().streamProject(project.id), // Listen for changes to the project data
          builder: (context, AsyncSnapshot<Project> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError || !snapshot.hasData) {
              return Text('Error loading project data');
            } else {
              Project updatedProject = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Project ID: ${updatedProject.id}'),
                  Text('Project Address: ${updatedProject.adresa}'),
                  // Add more project-specific information as needed
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProjectEditPage(project: updatedProject)),
                      );
                    },
                    child: Text('Edit Project'),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
