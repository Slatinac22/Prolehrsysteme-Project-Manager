import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/services/database.dart';
import 'package:project_manager/shared/colors.dart'; 
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors


class MontazaPage extends StatelessWidget {
      final String projectId;
  const MontazaPage({required this.projectId});

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Montaza',
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
                  _buildDataItem('Dobijen period za montazu', project.dobijen_period_za_montazu, context),
                   SizedBox(height: 20),
                  _buildDataItem('Planiran pocetak montaze', project.planiran_pocetak_montaze, context),
                    SizedBox(height: 20),
                  _buildDataItem('Pocetak montaze', project.pocetak_montaze, context),
                    SizedBox(height: 20),
                  _buildDataItem('Planiran zavrsetak montaze', project.planiran_zavrsetak_montaze, context),
                    SizedBox(height: 20),
                  _buildDataItem('Zavrsetak montaze', project.zavrsetak_montaze, context),
 
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