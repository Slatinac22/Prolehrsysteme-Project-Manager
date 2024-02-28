import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_manager/models/project.dart';


class Project {
  String naziv;
  String adresa;
  String id;
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


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




  Stream<Project> streamProject(String projectId) {
    return _firestore
        .collection('projects')
        .doc(projectId)
        .snapshots()
        .map((snapshot) => Project.fromSnapshot(snapshot));
  }




}
