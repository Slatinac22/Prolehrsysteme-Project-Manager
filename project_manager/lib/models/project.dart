import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart'; // Import the uuid package

class Project {
  String naziv;
  String adresa;
  String id;

  Project({
    required this.naziv,
    required this.adresa,
    required this.id,
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
