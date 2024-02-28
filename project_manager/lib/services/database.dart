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
}
