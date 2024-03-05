import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/screens/project_edit_page.dart';
import 'package:project_manager/screens/subscreens/defekti.dart';
import 'package:project_manager/screens/subscreens/kolicina.dart';
import 'package:project_manager/screens/subscreens/montaza.dart';
import 'package:project_manager/screens/subscreens/nabavka_i_produkcija.dart';
import 'package:project_manager/screens/subscreens/plan_produkcije.dart';
import 'package:project_manager/screens/subscreens/skladiste_i_transport.dart';
import 'package:project_manager/screens/subscreens/status.dart';
import 'package:project_manager/screens/subscreens/verifikacija_proekta.dart';
import 'package:project_manager/screens/subscreens/zahtevi.dart';
import 'package:project_manager/services/database.dart';
import 'package:project_manager/shared/colors.dart'; 
import 'package:project_manager/screens/subscreens/ponude.dart';

class ProjectDetailPage extends StatelessWidget {
  final Project project;

  ProjectDetailPage({required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text('${project.naziv} ${project.adresa}'),
      ),
      body: Center(
        child: StreamBuilder(
          stream: DatabaseService().streamProject(project.id),
          builder: (context, AsyncSnapshot<Project> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError || !snapshot.hasData) {
              return Text('Error loading project data');
            } else {
              Project updatedProject = snapshot.data!;
              return GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(16.0),
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                childAspectRatio: 3,
                children: [
                  buildButton(context, 'Ponude', PonudePage(projectId: updatedProject.id), Colors.blue),
                  buildButton(context, 'Plan Produkcije', PlanProdukcijePage(projectId: updatedProject.id), Colors.green),
                  buildButton(context, 'Nabavka i Produkcija', NabavkaIProdukcijaPage(projectId: updatedProject.id), Colors.orange),
                  buildButton(context, 'Skladiste i Transport', SkladisteITransportPage(projectId: updatedProject.id), Colors.purple),
                  buildButton(context, 'Montaza', MontazaPage(), Colors.red),
                  buildButton(context, 'Verifikacija Projekta', VerifikacijaProjektaPage(), Colors.teal),
                  buildButton(context, 'Kolicina', KolicinaPage(), Colors.indigo),
                  buildButton(context, 'Defekti', DefektiPage(), Colors.lime),
                  buildButton(context, 'Zahtevi', ZahteviPage(), Colors.amberAccent),
                  buildButton(context, 'Status', StatusPage(), Colors.brown),
                ],
              );
            }
          },
        ),
      ),
    );
  }

Widget buildButton(BuildContext context, String text, Widget destination, Color color) {
  if (text == 'Ponude' || text == 'Nabavka i Produkcija' || text == 'Plan Produkcije' || text == 'Skladiste i Transport') {
    String imageName = text == 'Ponude' ? 'handshake.jpg' : text == 'Nabavka i Produkcija' ? 'produkcija.jpg' : text == 'Plan Produkcije' ? 'planProdukcije.jpg' : 'skladiste_i_transport.jpg';
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            'assets/$imageName',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          top: text == 'Ponude' ? -10 : 0, // Adjust the top position based on the button text
          child: Container(
            color: text == 'Ponude' ? Colors.blue.withOpacity(0.5) : text == 'Nabavka i Produkcija' ? Colors.orange.withOpacity(0.5) : text == 'Plan Produkcije' ? Colors.green.withOpacity(0.5) : Colors.purple.withOpacity(0.5), // Blue color for 'Ponude', orange color for 'Nabavka i Produkcija', green color for 'Plan Produkcije', and purple color for 'Skladiste i Transport' with opacity
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => destination),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent, // Make the button background transparent
              onPrimary: color, // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Button border radius
              ),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.045,
                  fontFamily: 'Pacifico', // Example of using a custom font
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  decorationThickness: 2,
                  decorationStyle: TextDecorationStyle.double, // Use double line style
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  } else {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      style: ElevatedButton.styleFrom(
        primary: color, // Background color
        onPrimary: Colors.white, // Text color
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30), // Button padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Button border radius
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black, // Adding black color to the text
        ),
      ),
    );
  }
}

}
