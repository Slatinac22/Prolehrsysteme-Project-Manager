// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart'; // Import the uuid package

class Project {
  String naziv;
  String adresa;
  String ponuda;
  String datum_dobijanja_ponude;
  String status_ponude;
  String nabavka_materijala;
  String produkcija;
  String skladiste;
  String planirani_datum_transporta;
  String nije_planiran_datum_transporta;
  String poslato;
  String dobijen_period_za_montazu;
  String planiran_pocetak_montaze;
  String pocetak_montaze;
  String planiran_zavrsetak_montaze;
  String zavrsetak_montaze;
  String datum_verifikacije;
  String defekti;
  String datum_prijave_defekta;
  String status_transporta;
  String status_ponude_defekti;
  String zavrseno;
  String dodatni_zahtevi;
  String datum_dodatnog_zahteva;
  String status_ponude_zahtevi;
  String status_odobrenja_zahtevi;
  String broj_porudzbine;
  String status_zahteva;

  String planirani_pocetak_radova;
  String nalazi_se;
  String poslato_u_ch;
  String status_zavrseno;

  String kolicina;
  String id;

  Project({
    this.naziv = '',
    this.adresa = '',
    this.id = '',
    this.ponuda = ' ',
    this.datum_dobijanja_ponude = '',
    this.status_ponude = '',
    this.nabavka_materijala = '',
    this.produkcija = '',
    this.skladiste = '',
    this.planirani_datum_transporta = '',
    this.nije_planiran_datum_transporta = '',
    this.poslato = '',
    this.dobijen_period_za_montazu = '',
    this.planiran_pocetak_montaze = '',
    this.pocetak_montaze = '',
    this.planiran_zavrsetak_montaze = '',
    this.zavrsetak_montaze = '',
    this.datum_verifikacije = '',
    this.kolicina = '',
    this.defekti = '',
    this.datum_prijave_defekta = '',
    this.status_ponude_defekti = '',
    this.status_transporta = '',
    this.zavrseno = '',
    this.dodatni_zahtevi = '',
    this.datum_dodatnog_zahteva = '',
    this.broj_porudzbine = '',
    this.status_odobrenja_zahtevi = '',
    this.status_ponude_zahtevi = '',
    this.status_zahteva = '',

    this.planirani_pocetak_radova = '',
    this.nalazi_se = '',
    this.poslato_u_ch = '',
    this.status_zavrseno = '',




  });

  // Method to update the adresa property
  void updateAdresa(String newAdresa) {
    adresa = newAdresa;
  }

  void updateNaziv(String newNaziv) {
    naziv = newNaziv;
  }

  factory Project.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Project(
      id: snapshot.id,
      naziv: data['naziv'] ?? '',
      adresa: data['adresa'] ?? '',
      ponuda: data['ponuda'] ?? '',
      datum_dobijanja_ponude: data['datum_dobijanja_ponude'] ?? '',
      status_ponude: data['status_ponude'] ?? '',
      nabavka_materijala: data['nabavka_materijala'] ?? '',
      produkcija: data['produkcija'] ?? '',
      skladiste: data['skladiste'] ?? '',
      planirani_datum_transporta: data['planirani_datum_transporta'],
      nije_planiran_datum_transporta: data['nije_planiran_datum_transporta'],
      poslato: data['poslato'] ?? '',
      dobijen_period_za_montazu: data['dobijen_period_za_montazu'] ?? '',
      planiran_pocetak_montaze: data['planirani_pocetak_montaze'] ?? '',
      pocetak_montaze: data['pocetak_montaze'] ?? '',
      planiran_zavrsetak_montaze: data['planirani_zavrsetak_montaze'] ?? '',
      zavrsetak_montaze: data['zavrsetak_montaze'] ?? '',
      datum_verifikacije: data['datum_verifikacije'] ?? '',
      kolicina : data['kolicina'] ?? '',
      defekti: data['defekti'] ?? '',
      datum_prijave_defekta: data['datum_prijave_defekta'] ?? '',
      status_ponude_defekti: data['status_ponude_defekti'] ?? '',
      status_transporta: data['status_transporta'] ?? '',
      zavrseno: data['zavrseno'] ?? '',
      dodatni_zahtevi: data['dodatni_zahtevi'] ?? '',
      datum_dodatnog_zahteva: data['datum_dodatnog_zahteva'] ?? '',
      status_ponude_zahtevi: data['status_ponude_zahtevi'] ?? '',
      status_odobrenja_zahtevi: data['status_odobrenja_zahtevi'] ?? '',
      broj_porudzbine: data['broj_porudzbine'] ?? '',
      status_zahteva: data['status_zahteva'] ?? '',

      planirani_pocetak_radova: data['planirani_pocetak_radova'] ?? '',
      nalazi_se: data['nalazi_se'] ?? '',
      poslato_u_ch: data['poslato_u_ch'] ?? '',
      status_zavrseno: data['status_zavrseno'] ?? '',


    );
  }

  static String generateUniqueId() {
    var uuid = Uuid();
    return uuid.v4(); // Generate a random UUID
  }

  Stream<Project> streamProject(String projectId) {
    return FirebaseFirestore.instance
        .collection('projects')
        .doc(projectId)
        .snapshots()
        .map((snapshot) => Project.fromSnapshot(snapshot));
  }
}
