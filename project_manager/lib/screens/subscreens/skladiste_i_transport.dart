import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/services/database.dart';
import 'package:project_manager/shared/buildDataItem.dart';
import 'package:project_manager/shared/appBar.dart';



class SkladisteITransportPage extends StatelessWidget {
  final String projectId;

  const SkladisteITransportPage({required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:buildCustomAppBar('Skladište i Transport'),
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
                  buildDataItem('Skladište', project.skladiste),
                  SizedBox(height: 20),
                  buildDataItem('Planirani Datum Transporta', project.planirani_datum_transporta),
                  SizedBox(height: 20),
                  buildDataItem('Nije Planiran Datum Transporta uz Obrazloženje', project.nije_planiran_datum_transporta),
                  SizedBox(height: 20),
                  buildDataItem('Poslato - Datum:', project.poslato),
                  SizedBox(height: 20),
                ],
              );
            }
          },
        ),
      ),
    );
  }





}

