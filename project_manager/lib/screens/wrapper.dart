import 'package:flutter/material.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/screens/authenticate/authenticate.dart';
import 'package:project_manager/screens/home/home.dart';
import 'package:project_manager/services/auth.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key});

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    return StreamBuilder<HandmadeUser?>(
      stream: _auth.user, // Stream of user state from Firebase
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          final user = snapshot.data;

          // Return either Home or Authenticate based on the user's authentication status
          if (user == null) {
            return Authenticate();
          } else {
            return Home();
          }
        }
      },
    );
  }
}
