import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/services/database.dart';
import 'package:project_manager/shared/colors.dart'; 

class ZahteviPage extends StatelessWidget {

      final String projectId;

  const ZahteviPage({required this.projectId});


@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Zahtevi',
          style: TextStyle(  
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  _buildDataItem('Dodatni zahtevi', project.dodatni_zahtevi, context),
                   SizedBox(height: 20),
                  _buildDataItem('Datum dodatnog zahteva', project.datum_dodatnog_zahteva, context),
                  SizedBox(height: 20),
                  _buildDataItem('Status ponude', project.status_ponude_zahtevi, context),
                  SizedBox(height: 20),
                  _buildDataItem('Status odobrenja', project.status_odobrenja_zahtevi, context),
                  SizedBox(height: 20),
                  _buildDataItem('Broj porudzbine', project.broj_porudzbine, context),
                  SizedBox(height: 20),
                  _buildDataItem('Status zahteva', project.status_zahteva, context),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildDataItem(String title, String data, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: screenWidth > 600 ? 30 : 16, // Adjust font size based on screen width
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 5),
        Text(
          data,
          style: TextStyle(fontSize: screenWidth > 600 ? 30 : 14), // Adjust font size based on screen width
        ),
      ],
    );
  }
}