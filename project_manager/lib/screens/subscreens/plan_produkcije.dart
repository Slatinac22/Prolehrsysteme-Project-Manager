// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/services/database.dart';
import 'package:project_manager/shared/appBar.dart';
import 'package:project_manager/shared/buildDataItem.dart';


class PlanProdukcijePage extends StatelessWidget {

  final String projectId;

  const PlanProdukcijePage({required this.projectId});


 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildCustomAppBar('Plan produkcije'),
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
                  buildDataItem('Status plana produkcije:', project.plan_produkcije),
 
                ],
              );
            }
          },
        ),
      ),
    );
  }


}