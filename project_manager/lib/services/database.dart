import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_manager/models/brew.dart';
import 'package:project_manager/models/user.dart';

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


  // userData from snapshots
UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
  // Cast snapshot.data() to Map<String, dynamic>?
  Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

  // Check if data is not null before accessing its fields
  if (data != null) {
    // Retrieve values from the data map using the [] operator
    String uid = snapshot.id;
    String name = data['name'];
    String? sugars = data['sugars'];
    int? strength = data['strength'];

    // Return a new UserData object with the obtained values
    return UserData(
      uid: uid,
      name: name,
      sugars: sugars ?? '', // Providing a default value if 'sugars' is null
      strength: strength ?? 0, // Providing a default value if 'strength' is null
    );
  } else {
    // Handle the case where data is null (optional)
    // You can return a default UserData object or throw an error
    // For now, I'll return an empty UserData object
    return UserData(uid: '', name: '', sugars: '', strength: 0);
  }
}



  Stream<List<Brew>> get brews {
    return brewCollection.snapshots()
    .map((_brewListFromSnapshot));
  }

  //get user doc stream
  Stream<UserData> get userData{
    return brewCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
    
  


}
