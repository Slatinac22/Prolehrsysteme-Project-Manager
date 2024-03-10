import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/screens/project_edit_page.dart';
import 'package:project_manager/services/database.dart';

class AdminProjectDetailPage extends StatelessWidget {
  final Project project;

  AdminProjectDetailPage({required this.project});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    double textSize = screenSize.width < 600 ? 20.0 : 36.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(project.naziv),
        actions: [
          IconButton(
            onPressed: () {
              _editProject(context);
            },
            icon: Icon(Icons.edit, size: 30),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: DatabaseService().streamProject(project.id),
        builder: (context, AsyncSnapshot<Project> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('Error loading project data'));
          } else {
            Project updatedProject = snapshot.data!;
            return _buildGroupedCards(context, updatedProject);
          }
        },
      ),
    );
  }

  void _editProject(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProjectEditPage(project: project)),
    );
  }

  Widget _buildGroupedCards(BuildContext context, Project updatedProject) {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 1,
      childAspectRatio: MediaQuery.of(context).size.width > 600 ? 3 : 3,
      children: _buildCards(context, updatedProject),
    );
  }

  List<Widget> _buildCards(BuildContext context, Project updatedProject) {
    List<Widget> cards = [];
    List<List<String>> cardGroups = [
      ['Naziv projekta', 'Adresa projekta'],
      ['Ponuda', 'Datum dobijanja ponude', 'Status ponude'],
      ['Plan produkcije'],
      ['Nabavka materijala', 'Produkcija'],
      ['Skladiste', 'Planirani datum transporta', 'Nije planiran datum transporta uz obrazlozenje', 'Poslato'],
      ['Dobijen period za montazu', 'Planirani pocetak montaze', 'Pocetak montaze', 'Planirani zavrsetak montaze', 'Zavrsetak montaze'],
      ['Datum verifikacije'],
      ['Defekti', 'Datum prijave defekta', 'Status transporta', 'Status ponude (Defekti)', 'Zavrseno'],
      ['Dodatni zahtevi', 'Datum dodatnog zahteva', 'Status ponude (Zahtevi)', 'Status odobrenja', 'Broj porudzbine', 'Status zahteva'],
      ['Planirani pocetak radova', 'Nalazi se', 'Poslato u CH', 'Finalni status'],
      ['Kolicina'],
    ];

    for (var group in cardGroups) {
      for (var label in group) {
        cards.add(_buildDetailCard(label, _detailValues(updatedProject)[_detailLabels.indexOf(label)]));
      }
    }

    return cards;
  }

  Widget _buildDetailCard(String label, String value) {
    return Card(
      elevation: 2.0,
      child: ListTile(
        title: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value),
        contentPadding: EdgeInsets.all(16.0),
      ),
    );
  }

  List<String> _detailLabels = [
    'Naziv projekta',
    'Adresa projekta',
    'Ponuda',
    'Datum dobijanja ponude',
    'Status ponude',
    'Plan produkcije',
    'Nabavka materijala',
    'Produkcija',
    'Skladiste',
    'Planirani datum transporta',
    'Nije planiran datum transporta uz obrazlozenje',
    'Poslato',
    'Dobijen period za montazu',
    'Planirani pocetak montaze',
    'Pocetak montaze',
    'Planirani zavrsetak montaze',
    'Zavrsetak montaze',
    'Datum verifikacije',
    'Defekti',
    'Datum prijave defekta',
    'Status transporta',
    'Status ponude (Defekti)',
    'Zavrseno',
    'Dodatni zahtevi',
    'Datum dodatnog zahteva',
    'Status ponude (Zahtevi)',
    'Status odobrenja',
    'Broj porudzbine',
    'Status zahteva',
    'Planirani pocetak radova',
    'Nalazi se',
    'Poslato u CH',
    'Finalni status',
    'Kolicina',
  ];

  List<String> _detailValues(Project project) {
    return [
      project.naziv,
      project.adresa,
      project.ponuda,
      project.datum_dobijanja_ponude,
      project.status_ponude,
      project.plan_produkcije,
      project.nabavka_materijala,
      project.produkcija,
      project.skladiste,
      project.planirani_datum_transporta,
      project.nije_planiran_datum_transporta,
      project.poslato,
      project.dobijen_period_za_montazu,
      project.planiran_pocetak_montaze,
      project.pocetak_montaze,
      project.planiran_zavrsetak_montaze,
      project.zavrsetak_montaze,
      project.datum_verifikacije,
      project.defekti,
      project.datum_prijave_defekta,
      project.status_transporta,
      project.status_ponude_defekti,
      project.zavrseno,
      project.dodatni_zahtevi,
      project.datum_dodatnog_zahteva,
      project.status_ponude_zahtevi,
      project.status_odobrenja_zahtevi,
      project.broj_porudzbine,
      project.status_zahteva,
      project.planirani_pocetak_radova,
      project.nalazi_se,
      project.poslato_u_ch,
      project.status_zavrseno,
      project.kolicina,
    ];
  }
}
