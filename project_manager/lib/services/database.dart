import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_manager/models/brew.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');

  Future<void> updateUserData(
      String sugars, String name, int strength) async {
    if (uid != null) {
      await brewCollection.doc(uid!).set({
        'sugars': sugars,
        'name': name,
        'strength': strength,
      });
    } else {
      throw Exception('User ID is null. Cannot update user data.');
    }
  }


  // brew list from snapshot
List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>; // Cast to the correct type
    return Brew(
      name: data['name'] ?? '', // Handle nullability
      strength: data['strength'] ?? 0,
      sugars: data['sugars'] ?? '0', // Correct the typo in 'sugars'
    );
  }).toList();
}



  Stream<List<Brew>> get brews {
    return brewCollection.snapshots()
    .map((_brewListFromSnapshot));
  }
}
