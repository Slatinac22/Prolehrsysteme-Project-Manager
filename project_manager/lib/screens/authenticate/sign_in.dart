import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_manager/services/auth.dart';


class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[200],
      appBar: AppBar(
        backgroundColor: Colors.purple[400],
        title: Text('Sign in'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: ElevatedButton(
          child: Text("Sign in"),
          onPressed: () async{
            
              dynamic result = await _auth.signInAnon();
              if(result == null){
                print('Error signing in');
              }
              else{
                print('Signed in');
              print(result.uid);


              }
          },
          ),
      ),
    );
  }
}