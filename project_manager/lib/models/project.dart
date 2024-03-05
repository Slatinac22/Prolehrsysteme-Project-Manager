// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart'; // Import the uuid package

class Project {
  String naziv;
  String adresa;
  String ponuda;
  String datum_dobijanja_ponude;
  String status_ponude;
  String id;

  Project({
     this.naziv = '',
     this.adresa = '',
     this.id = '',
    this.ponuda = ' ',
    this.datum_dobijanja_ponude = '',
    this.status_ponude = '',
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
