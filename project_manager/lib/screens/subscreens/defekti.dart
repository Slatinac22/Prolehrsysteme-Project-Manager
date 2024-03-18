
import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/services/database.dart';
import 'package:project_manager/shared/appBar.dart';
import 'package:project_manager/shared/buildDataItem.dart';


class DefektiPage extends StatelessWidget {
  final String projectId;
  
  const DefektiPage({required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildCustomAppBar('Defekti'), 
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
                  buildDataItem('Defekti', project.defekti),
                  SizedBox(height: 20),
                  buildDataItem('Datum prijave defekta', project.datum_prijave_defekta),
                  SizedBox(height: 20),
                  buildDataItem('Status transporta', project.status_transporta),
                  SizedBox(height: 20),
                  buildDataItem('Status ponude', project.status_ponude_defekti),
                  SizedBox(height: 20),
                  buildDataItem('Zavrseno', project.zavrseno),                                    
                ],
              );
            }
          },
        ),
      ),
    );
  }


}
