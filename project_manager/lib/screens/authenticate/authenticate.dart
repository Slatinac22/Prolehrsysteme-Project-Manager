// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:project_manager/screens/authenticate/sign_in.dart';



class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {


  bool showSignIn = true;

  void toggleView() {
    setState(() => showSignIn = !showSignIn); 
    }
  

  @override
  Widget build(BuildContext context) {
  

        return SignIn(toggleView: toggleView);
      

 
  }
} 