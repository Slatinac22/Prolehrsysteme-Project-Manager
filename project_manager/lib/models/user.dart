
class HandmadeUser {
  final String? uid;
  HandmadeUser({this.uid});
}


class UserData{

  final String uid;
  final String name;
  final String sugars;
  final int strength;


//constructor
  UserData({
  required this.uid,
  required this.sugars,
  required this.strength,
  required this.name
  });
}