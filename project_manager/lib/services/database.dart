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
        'naziv': project.naziv,
        'adresa': project.adresa,
        // Add other fields if needed
      });
    } catch (e) {
      print('Error adding project: $e');
    }
  }


}



