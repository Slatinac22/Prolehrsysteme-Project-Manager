import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/services/database.dart';
import 'package:project_manager/shared/colors.dart'; 
import 'package:project_manager/shared/appBar.dart';
import 'package:project_manager/shared/buildDataItem.dart';


class PonudePage extends StatelessWidget {
  final String projectId;

  PonudePage({required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildCustomAppBar('Ponude'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<Project>(
          stream: DatabaseService().streamProject(projectId),
          builder: (context, AsyncSnapshot<Project> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error fetching project data', style: TextStyle(color: Colors.red, fontSize: 18)));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No project data available', style: TextStyle(color: Colors.red, fontSize: 18)));
            } else {
              Project project = snapshot.data!;
              return ListView(
                children: [
                  SizedBox(height: 20),
                  buildDataItem('Ponuda:', project.ponuda),
                  SizedBox(height: 20),
                  buildDataItem('Datum Dobijanja Ponude:', project.datum_dobijanja_ponude),
                  SizedBox(height: 20),
                  buildDataItem('Status Ponude:', project.status_ponude),
                ],
              );
            }
          },
        ),
      ),
    );
  }




}
