// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/services/database.dart';
import 'package:project_manager/shared/addProjectInputBox.dart';

class AddProjectPage extends StatefulWidget {
  @override
  _AddProjectPageState createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final TextEditingController _nazivController = TextEditingController();
  final TextEditingController _adresaController = TextEditingController();
  final TextEditingController _ponudaController = TextEditingController();
  final TextEditingController _datumPonudeController = TextEditingController();
  final TextEditingController _statusPonudeController = TextEditingController();
  final TextEditingController _planProdukcijeController = TextEditingController();
  final TextEditingController _nabavkaMaterijalaController = TextEditingController();
  final TextEditingController _produkcijaIzradaController = TextEditingController();
  final TextEditingController _skladisteController = TextEditingController();
  final TextEditingController _planiraniDatumTransportaController = TextEditingController();
  final TextEditingController _nijePlaniranDatumTransportaController = TextEditingController();
  final TextEditingController _poslatoController = TextEditingController();
  final TextEditingController _dobijenPeriodZaMontazuController = TextEditingController();
  final TextEditingController _planiranPocetakMontazeController = TextEditingController();
  final TextEditingController _pocetakMontazeController = TextEditingController();
  final TextEditingController _planiranZavrsetakMontazeController = TextEditingController();
  final TextEditingController _zavrsetakMontazeController = TextEditingController();
  final TextEditingController _datumVerifikacijeController = TextEditingController();
  final TextEditingController _kolicinaController = TextEditingController();
  final TextEditingController _defektiController = TextEditingController();
  final TextEditingController _datumPrijaveDefektaController = TextEditingController();
  final TextEditingController _statusTransportaController = TextEditingController();
  final TextEditingController _statusPonudeDefektiController = TextEditingController();
  final TextEditingController _zavrsenoController = TextEditingController();
  final TextEditingController _dodatniZahteviController = TextEditingController();
  final TextEditingController _datumDodatnogZahtevaController = TextEditingController();
  final TextEditingController _statusPonudeZahteviController = TextEditingController();
  final TextEditingController _statusOdobrenjaZahteviController = TextEditingController();
  final TextEditingController _brojPorudzbinaController = TextEditingController();
  final TextEditingController _statusZahtevaController = TextEditingController();
  final TextEditingController _planiraniPocetakRadovaController = TextEditingController();
  final TextEditingController _nalaziSeController = TextEditingController();
  final TextEditingController _poslatoCHController = TextEditingController();
  final TextEditingController _statusZavresnoController = TextEditingController();


  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Project'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Osnovni podaci'),
              _buildInputField(_nazivController, 'Naziv projekta'),
              _buildInputField(_adresaController, 'Adresa projekta'),
              _buildSectionTitle('Ponude'),
              _buildInputField(_ponudaController, 'Sta se trazi u ponudi'),
              _buildInputField(_datumPonudeController, 'Datum dobijanja ponude'),
              _buildInputField(_statusPonudeController, 'Status ponude'),
              _buildSectionTitle('Plan produkcije'),
              _buildInputField(_planProdukcijeController, 'Status plana produkcije'),
              _buildSectionTitle('Nabavka i produkcija'),
              _buildInputField(_nabavkaMaterijalaController, 'Nabavka materijala'),
              _buildInputField(_produkcijaIzradaController, 'Produkcija - Izrada'),
              _buildSectionTitle('Skladiste i transport'),
              _buildInputField(_skladisteController, 'Skladiste'),
              _buildInputField(_planiraniDatumTransportaController, 'Planirani datum transporta'),
              _buildInputField(_nijePlaniranDatumTransportaController, 'Nije planiran datum uz obrazlosenje'),
              _buildInputField(_poslatoController, 'Poslato (Datum)'),
              _buildSectionTitle('Montaza'),
              _buildInputField(_dobijenPeriodZaMontazuController, 'Dobijen period za montazu'),
              _buildInputField(_planiranPocetakMontazeController, 'Planiran pocetak montaze'),
              _buildInputField(_pocetakMontazeController, 'Pocetak montaze'),
              _buildInputField(_planiranZavrsetakMontazeController, 'Planiran zavrsetak montaze'),
              _buildInputField(_zavrsetakMontazeController, 'Zavrsetak montaze'),
              _buildSectionTitle('Datum verifikacije projekta'),
              _buildInputField(_datumVerifikacijeController, 'Datum verifikacije projekta'),
              _buildSectionTitle('Kolicina (Produkcija SRB)'),
              _buildInputField(_kolicinaController, 'Kolicina'),
              _buildSectionTitle('Defekti'),
              _buildInputField(_defektiController, 'Defekti'),
              _buildInputField(_datumPrijaveDefektaController, 'Datum prijave defekta'),
              _buildInputField(_statusTransportaController, 'Status transporta'),
              _buildInputField(_statusPonudeDefektiController, 'Status ponude'),
              _buildInputField(_zavrsenoController, 'Zavrseno'),
              _buildSectionTitle('Zahtevi'),
              _buildInputField(_dodatniZahteviController, 'Dodatni zahtevi'),
              _buildInputField(_datumDodatnogZahtevaController, 'Datum dodatnog zahteva'),
              _buildInputField(_statusPonudeZahteviController, 'Status ponude'),
              _buildInputField(_statusOdobrenjaZahteviController, 'Status odobrenja'),
              _buildInputField(_brojPorudzbinaController, 'Broj porudzbine'),
              _buildInputField(_statusZahtevaController, 'Status zahteva'),
              _buildSectionTitle('Status'),
              _buildInputField(_planiraniPocetakRadovaController, 'Planiran pocetak radova'),
              _buildInputField(_nalaziSeController, 'Nalazi se'),
              _buildInputField(_poslatoCHController, 'Poslato u CH'),
              _buildInputField(_statusZavresnoController, 'Zavrseno'),
              SizedBox(height: 20),
              _buildButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
                maxLines: null,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _addProject();
        },
        child: Text('Add Project'),
      ),
    );
  }
  void _addProject() {
    String naziv = _nazivController.text.trim();
    String adresa = _adresaController.text.trim();
    String ponuda = _ponudaController.text.trim();
    String datumPonude = _datumPonudeController.text.trim();
    String statusPonude = _statusPonudeController.text.trim();
    String plan_produkcije = _planProdukcijeController.text.trim();
    String nabavka_materijala = _nabavkaMaterijalaController.text.trim();
    String produkcija = _produkcijaIzradaController.text.trim();
    String skladiste = _skladisteController.text.trim();
    String planirani_datum_transporta = _planiraniDatumTransportaController.text.trim();
    String nije_planiran_datum_transporta = _nijePlaniranDatumTransportaController.text.trim();
    String poslato = _poslatoController.text.trim();
    String dobijen_period_za_montazu = _dobijenPeriodZaMontazuController.text.trim();
    String planiran_pocetak_montaze = _planiranPocetakMontazeController.text.trim();
    String pocetak_montaze = _pocetakMontazeController.text.trim();
    String planiran_zavrsetak_montaze = _planiranZavrsetakMontazeController.text.trim();
    String zavrsetak_montaze = _zavrsetakMontazeController.text.trim();
    String datum_verifikacije = _datumVerifikacijeController.text.trim();
    String kolicina = _kolicinaController.text.trim();
    String defekti = _defektiController.text.trim();
    String datum_prijave_defekta = _datumPrijaveDefektaController.text.trim();
    String status_transporta = _statusTransportaController.text.trim();
    String status_ponude_defekti = _statusPonudeDefektiController.text.trim();
    String zavrseno = _zavrsenoController.text.trim();
    String dodatni_zahtevi = _dodatniZahteviController.text.trim();
    String datum_dodatnog_zahteva = _datumDodatnogZahtevaController.text.trim();
    String status_ponude_zahtevi = _statusPonudeZahteviController.text.trim();
    String status_odobrenja_zahtevi = _statusOdobrenjaZahteviController.text.trim();
    String broj_porudzbine = _brojPorudzbinaController.text.trim();
    String status_zahteva = _statusZahtevaController.text.trim();
    String planirani_pocetak_radova = _planiraniPocetakRadovaController.text.trim();
    String nalazi_se = _nalaziSeController.text.trim();
    String poslato_u_ch = _poslatoCHController.text.trim();
    String status_zavrseno = _statusZavresnoController.text.trim();





    String projectId = Project.generateUniqueId();



      Project project = Project(
        naziv: naziv,
        adresa: adresa,
        id: projectId,
        ponuda: ponuda,
        datum_dobijanja_ponude: datumPonude,
        status_ponude: statusPonude,
        plan_produkcije: plan_produkcije,
        nabavka_materijala: nabavka_materijala,
        produkcija: produkcija,
        skladiste: skladiste,
        planirani_datum_transporta: planirani_datum_transporta,
        nije_planiran_datum_transporta: nije_planiran_datum_transporta,
        poslato: poslato,
        dobijen_period_za_montazu: dobijen_period_za_montazu,
        planiran_pocetak_montaze: planiran_pocetak_montaze,
        pocetak_montaze: pocetak_montaze,
        planiran_zavrsetak_montaze: planiran_zavrsetak_montaze,
        zavrsetak_montaze: zavrsetak_montaze,
        datum_verifikacije: datum_verifikacije,
        kolicina: kolicina,
        defekti: defekti,
        datum_prijave_defekta: datum_prijave_defekta,
        status_transporta: status_transporta,
        status_ponude_defekti: status_ponude_defekti,
        zavrseno: zavrseno,
        dodatni_zahtevi: dodatni_zahtevi,
        datum_dodatnog_zahteva: datum_dodatnog_zahteva,
        status_ponude_zahtevi: status_ponude_zahtevi,
        status_odobrenja_zahtevi: status_odobrenja_zahtevi,
        broj_porudzbine: broj_porudzbine,
        status_zahteva: status_zahteva,
        planirani_pocetak_radova: planirani_pocetak_radova,
        nalazi_se: nalazi_se,
        poslato_u_ch: poslato_u_ch,
        status_zavrseno: status_zavrseno,
      );

      _databaseService.addProject(project);



      Navigator.pop(context);
    }

    
  }

