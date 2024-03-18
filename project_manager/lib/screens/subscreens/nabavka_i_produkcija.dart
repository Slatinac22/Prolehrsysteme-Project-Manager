// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/services/database.dart';
import 'package:project_manager/shared/buildDataItem.dart';
import 'package:project_manager/shared/appBar.dart';




class NabavkaIProdukcijaPage extends StatelessWidget {
  
    final String projectId;
    
  const NabavkaIProdukcijaPage({required this.projectId});

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildCustomAppBar('Nabavka i Produkcija'),
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
                  buildDataItem('Nabavka materijala', project.nabavka_materijala),
                   SizedBox(height: 20),
                  buildDataItem('Produkcija - Izrada', project.produkcija),
 
                ],
              );
            }
          },
        ),
      ),
    );
  }




}