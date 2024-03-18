import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/services/database.dart';
import 'package:project_manager/shared/appBar.dart';
import 'package:project_manager/shared/buildDataItem.dart';
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors


class MontazaPage extends StatelessWidget {
      final String projectId;
  const MontazaPage({required this.projectId});

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:buildCustomAppBar('Montaza'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<Project>(
          stream: DatabaseService().streamProject(projectId),
          builder: (context, AsyncSnapshot<Project> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error fetching project data'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No project data available'));
            } else {
              Project project = snapshot.data!;
              return ListView(
                children: [
                  SizedBox(height: 20),
                  buildDataItem('Dobijen period za montazu', project.dobijen_period_za_montazu),
                   SizedBox(height: 20),
                  buildDataItem('Planiran pocetak montaze', project.planiran_pocetak_montaze),
                    SizedBox(height: 20),
                  buildDataItem('Pocetak montaze', project.pocetak_montaze),
                    SizedBox(height: 20),
                  buildDataItem('Planiran zavrsetak montaze', project.planiran_zavrsetak_montaze),
                    SizedBox(height: 20),
                  buildDataItem('Zavrsetak montaze', project.zavrsetak_montaze),
 
                ],
              );
            }
          },
        ),
      ),
    );
  }



}