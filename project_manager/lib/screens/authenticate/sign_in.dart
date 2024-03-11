// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_manager/services/auth.dart';
import 'package:project_manager/shared/constants.dart';
import 'package:project_manager/shared/loading.dart';
import 'dart:ui';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // Text field state
  String email = '';
  String password = '';
  String error = '';

  // Timer for debouncing
 

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Color.fromARGB(100, 60, 181, 208),
            body: screenWidth > 600
                ? _buildDesktopLayout()
                : _buildMobileLayout(),
          );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.white,
            child: Image.asset(
              'assets/signInImage.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: _buildForm(),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.transparent,
            child: Image.asset(
              'assets/signInImage.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: _buildForm(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 100.0),
              Text(
                'Dobrodošli',
                style: TextStyle(
                  
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                   fontFamily: 'Oswald',
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.grey.withOpacity(0.5),
                      offset: Offset(4, 4),
                      blurRadius: 10,
                    ),
                    Shadow(
                      color: Colors.white.withOpacity(0.5),
                      offset: Offset(-4, -4),
                      blurRadius: 10,
                    ),
                 ],
                ),
              ),
                Text(
                'Ulogujte se na svoj nalog :',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                   fontFamily: 'Roboto',
                  color: Colors.white70,
                  shadows: [
                    Shadow(
                      color: Colors.grey.withOpacity(0.5),
                      offset: Offset(4, 4),
                      blurRadius: 10,
                    ),
                    Shadow(
                      color: Colors.white.withOpacity(0.5),
                      offset: Offset(-4, -4),
                      blurRadius: 10,
                    ),
                 ],
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                'Email',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                 fontFamily: 'Roboto',

                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.grey.withOpacity(0.5),
                      offset: Offset(4, 4),
                      blurRadius: 10,
                    ),
                    Shadow(
                      color: Colors.white.withOpacity(0.5),
                      offset: Offset(-4, -4),
                      blurRadius: 10,
                    ),
                 ],                  
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                              
                decoration: InputDecoration(
                  hintText: 'E-Mail',
                  hintStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(Icons.email, color:Colors.black),
                  filled: true,
                  fillColor: Color.fromARGB(170, 255, 255, 255),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.white, // Border color when focused
                    ),
                  ),
                ),
                validator: (val) => val!.isEmpty ? 'Unesi E-Mail' : null,
                onChanged: (val) {
                  setState(() {
                    email = val; // Update email variable here
                  });
                },

              ),
              SizedBox(height: 20.0),
              Text(
                'Password',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.grey.withOpacity(0.5),
                      offset: Offset(4, 4),
                      blurRadius: 10,
                    ),
                    Shadow(
                      color: Colors.white.withOpacity(0.5),
                      offset: Offset(-4, -4),
                      blurRadius: 10,
                    ),
                 ],                  
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
  decoration: InputDecoration(
    hintText: 'Lozinka',
    hintStyle: TextStyle(color: Colors.black),
    prefixIcon: Icon(Icons.lock, color: Colors.black),
    filled: true,
    fillColor: Color.fromARGB(170, 255, 255, 255),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: Colors.white, // White border color
        width: 2.0, // Increased border width
      ),
    ),
  ),
  style: TextStyle(color: Colors.black),
  validator: (val) =>
      val!.length < 6 ? 'Unesi lozinku koja ima 6+ karaktera' : null,
  obscureText: true,
  onChanged: (val) {
    setState(() {
      password = val; // Update password variable here
    });
  },
       

              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    setState(() => loading = true);
                    dynamic result =
                        await _auth.signInWithEmailPassword(email, password);

                    if (result == null) {
                      setState(() {
                        error = 'Could not sign in with those credentials';
                        loading = false;
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  shadowColor: Colors.black,
                ),
                child: loading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Uloguj se',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.black, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
 
    super.dispose();
  }
}
