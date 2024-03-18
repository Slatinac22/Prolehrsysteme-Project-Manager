import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/services/database.dart';
import 'package:project_manager/shared/appBar.dart';
import 'package:project_manager/shared/buildDataItem.dart';

class ZahteviPage extends StatelessWidget {

      final String projectId;

  const ZahteviPage({required this.projectId});


@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar('Zahtevi'),
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
                  buildDataItem('Dodatni zahtevi', project.dodatni_zahtevi),
                   SizedBox(height: 20),
                  buildDataItem('Datum dodatnog zahteva', project.datum_dodatnog_zahteva),
                  SizedBox(height: 20),
                  buildDataItem('Status ponude', project.status_ponude_zahtevi),
                  SizedBox(height: 20),
                  buildDataItem('Status odobrenja', project.status_odobrenja_zahtevi),
                  SizedBox(height: 20),
                  buildDataItem('Broj porudzbine', project.broj_porudzbine),
                  SizedBox(height: 20),
                  buildDataItem('Status zahteva', project.status_zahteva),
                ],
              );
            }
          },
        ),
      ),
    );
  }


}