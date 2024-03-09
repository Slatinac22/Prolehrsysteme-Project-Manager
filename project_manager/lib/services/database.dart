import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_manager/models/project.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Project>> fetchProjects() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('projects').get();
      List<Project> projects = [];
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data != null) {
          projects.add(Project(
            id: doc.id,
            naziv: data['naziv'] ?? '',
            adresa: data['adresa'] ?? '',
          ));
        }
      });
      return projects;
    } catch (e) {
      print('Error fetching projects: $e');
      return []; // Return an empty list to indicate failure
    }
  }
Stream<List<Project>> streamProjects() {
    return _firestore.collection('projects').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Project(
          id: doc.id,
          naziv: doc['naziv'],
          adresa: doc['adresa'],
        );
      }).toList();
    });
  }


List<Project> _mapQuerySnapshotToProjects(QuerySnapshot snapshot, String query) {
  // If the query is empty, return all projects
  if (query.isEmpty) {
    return snapshot.docs.map((doc) => Project.fromSnapshot(doc)).toList();
  }

  // Otherwise, filter projects based on the search query
  return snapshot.docs
      .map((doc) => Project.fromSnapshot(doc))
      .where((project) => project.naziv.toLowerCase().contains(query.toLowerCase()))
      .toList();
}


  // Fetch user role from Firestore collection
// In auth.dart

Future<String?> getUserRole(String uid) async {
  try {
    // Fetch user document from Firestore users collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: uid).get();
    
    if (querySnapshot.docs.isNotEmpty) {
      // There should be only one user document with the provided UID
      // Get the first document from the query snapshot
      DocumentSnapshot userData = querySnapshot.docs.first;

      // Extract the role field from the user data
      String? userRole = userData['role'] as String?;
      return userRole;
    } else {
      print('User document not found for UID: $uid');
      return null;
    }
  } catch (e) {
    print('Error fetching user role: $e');
    return null;
  }
}


Future<Map<String, dynamic>?> getUserData(String uid) async {
  try {
    DocumentSnapshot snapshot = await _firestore.collection('users').doc(uid).get();
    return snapshot.data() as Map<String, dynamic>?; // Cast the return value to the correct type
  } catch (e) {
    print('Error fetching user data: $e');
    return null;
  }
}



  Stream<Project> streamProject(String projectId) {
    return _firestore
        .collection('projects')
        .doc(projectId)
        .snapshots()
        .map((snapshot) => Project.fromSnapshot(snapshot));
  }

  Future<void> updateProjectAdresa(String projectId, String newAdresa) async {
    try {
      await _firestore
          .collection('projects')
          .doc(projectId)
          .update({'adresa': newAdresa});
    } catch (e) {
      print('Error updating project adresa: $e');
      throw e;
    }
  }

  Future<void> updateProjectNaziv(String projectId, String newNaziv) async {
    try {
      await _firestore
          .collection('projects')
          .doc(projectId)
          .update({'naziv': newNaziv});
    } catch (e) {
      print('Error updating project naziv: $e');
      throw e;
    }
  }
Future<void> deleteProject(String projectId) async {
  try {
    if (projectId != null && projectId.isNotEmpty) {
      await _firestore.collection('projects').doc(projectId).delete();
      print('Project deleted successfully');
    } else {
      print('Project ID is null or empty');
    }
  } catch (e) {
    print('Error deleting project: $e');
    // Handle error gracefully, such as showing an error message to the user
    throw e;
  }
}


  
Future<void> addProject(Project project) async {
  try {
    await _firestore.collection('projects').add({
      'id': project.id,
      'naziv': project.naziv,
      'adresa': project.adresa,
      'ponuda': project.ponuda,
      'datum_dobijanja_ponude': project.datum_dobijanja_ponude,
      'status_ponude': project.status_ponude,
      'plan_produkcije': project.plan_produkcije,
      'nabavka_materijala': project.nabavka_materijala,
      'produkcija': project.produkcija,
      'skladiste': project.skladiste,
      'planirani_datum_transporta': project.planirani_datum_transporta,
      'nije_planiran_datum_transporta': project.nije_planiran_datum_transporta,
      'poslato': project.poslato,
      'dobijen_period_za_montazu': project.dobijen_period_za_montazu,
      'planirani_pocetak_montaze': project.planiran_pocetak_montaze,
      'pocetak_montaze': project.pocetak_montaze,
      'planirani_zavrsetak_montaze': project.planiran_zavrsetak_montaze,
      'zavrsetak_montaze': project.zavrsetak_montaze,
      'datum_verifikacije': project.datum_verifikacije,
      'kolicina': project.kolicina,
      'defekti': project.defekti,
      'datum_prijave_defekta': project.datum_prijave_defekta,
      'status_transporta': project.status_transporta,
      'status_ponude_defekti': project.status_ponude_defekti,
      'zavrseno': project.zavrseno,
      'dodatni_zahtevi': project.dodatni_zahtevi,
      'datum_dodatnog_zahteva': project.datum_dodatnog_zahteva,
      'status_ponude_zahtevi': project.status_ponude_zahtevi,
      'status_odobrenja_zahtevi': project.status_odobrenja_zahtevi,
      'broj_porudzbine': project.broj_porudzbine,
      'status_zahteva': project.status_zahteva,
      'planirani_pocetak_radova': project.planirani_pocetak_radova,
      'nalazi_se': project.nalazi_se,
      'poslato_u_ch': project.poslato_u_ch,
      'status_zavrseno': project.status_zavrseno,
      // Add other fields if needed
    });
  } catch (e) {
    print('Error adding project: $e');
  }
}



}



