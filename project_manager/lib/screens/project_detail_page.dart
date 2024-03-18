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
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: Material(
          elevation: 10, // Add elevation here
          child: AppBar(
            backgroundColor: AppColors.secondaryColor,
            centerTitle: true,
            title: Text(
              '${project.naziv} ${project.adresa}', // App bar title from the first code
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
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
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
                padding: EdgeInsets.all(16.0),
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                childAspectRatio: 3,
                children: [
                  buildButton(
                    context,
                    'Ponude',
                    PonudePage(projectId: updatedProject.id),
                    Colors.blue,
                    'handshake.jpg',
                  ),
                  buildButton(
                    context,
                    'Plan Produkcije',
                    PlanProdukcijePage(projectId: updatedProject.id),
                    Colors.green,
                    'planProdukcije.jpg',
                  ),
                  buildButton(
                    context,
                    'Nabavka i Produkcija',
                    NabavkaIProdukcijaPage(projectId: updatedProject.id),
                    Colors.orange,
                    'produkcija.jpg',
                  ),
                  buildButton(
                    context,
                    'Skladiste i Transport',
                    SkladisteITransportPage(projectId: updatedProject.id),
                    Colors.purple,
                    'skladiste_i_transport.jpg',
                  ),
                  buildButton(
                    context,
                    'Montaza',
                    MontazaPage(projectId: updatedProject.id),
                    Colors.red,
                    'montaza.jpg',
                  ),
                  buildButton(
                    context,
                    'Verifikacija Projekta',
                    VerifikacijaProjektaPage(projectId: updatedProject.id),
                    Colors.teal,
                    'verifikacija.jpg',
                  ),
                  buildButton(
                    context,
                    'Kolicina',
                    KolicinaPage(projectId: updatedProject.id),
                    Colors.indigo,
                    'kolicina.jpg',
                  ),
                  buildButton(
                    context,
                    'Defekti',
                    DefektiPage(projectId: updatedProject.id),
                    Colors.white30,
                    'defekti.jpg',
                  ),
                  buildButton(
                    context,
                    'Zahtevi',
                    ZahteviPage(projectId: updatedProject.id),
                    Colors.amberAccent,
                    'zahtevi.jpg',
                  ),
                  buildButton(
                    context,
                    'Status',
                    StatusPage(projectId: updatedProject.id),
                    Colors.brown,
                    'status.jpg',
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String text, Widget destination,
      Color color, String imageName) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(10), // Border radius to cut the edges
          ),
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            'assets/$imageName',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          top: text == 'Ponude'
              ? -10
              : 0, // Adjust the top position based on the button text
          child: Container(
            color: text == 'Ponude'
                ? Colors.blue.withOpacity(0.3)
                : text == 'Nabavka i Produkcija'
                    ? Colors.orange.withOpacity(0.3)
                    : text == 'Plan Produkcije'
                        ? Colors.green.withOpacity(0.3)
                        : text == 'Skladiste i Transport'
                            ? Colors.purple.withOpacity(0.3)
                            : text == 'Montaza'
                                ? Colors.red.withOpacity(0.3)
                                : text == 'Verifikacija Projekta'
                                    ? Colors.teal.withOpacity(0.3)
                                    : text == 'Kolicina'
                                        ? Colors.indigo.withOpacity(0.3)
                                        : text == 'Defekti'
                                            ? Colors.white30.withOpacity(0.3)
                                            : text == 'Zahtevi'
                                                ? Colors.amberAccent
                                                    .withOpacity(0.5)
                                                : Colors.brown.withOpacity(0.3),
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
              backgroundColor:
                  Colors.transparent, // Make the button background transparent
              // Text color
              shape: RoundedRectangleBorder(
                  // Button border radius
                  ),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width > 600 ? 50 : 36,
                  fontFamily: 'Pacifico', // Example of using a custom font
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  decorationThickness: 2,
                  decorationStyle:
                      TextDecorationStyle.double, // Use double line style
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
  }
}
