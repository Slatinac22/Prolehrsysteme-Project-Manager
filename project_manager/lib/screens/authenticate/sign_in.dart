import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_manager/services/auth.dart';
import 'package:project_manager/shared/constants.dart';
import 'package:project_manager/shared/loading.dart';

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

  //Text field state
  String email = '';
  String password = '';
  String error = '';

  // Timer for debouncing
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Color.fromARGB(100, 60, 181, 208),
            body: Row(
              children: [
                screenWidth > 600 // Check if screen width is greater than 600 (for tablet/desktop)
                    ? Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.white, // Set the container background color
                          child: Image.asset(
                            'assets/signInImage.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : SizedBox(), // Hide the image if screen width is less than or equal to 600 (for mobile)
                Expanded(
                  flex: screenWidth > 600 ? 1 : 2, // Adjust flex value based on screen width
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Dobrodošli',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 50,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 30.0),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'E-Mail',
                              prefixIcon: Icon(Icons.email), // Add email icon
                            ),
                            validator: (val) => val!.isEmpty ? 'Unesi E-Mail' : null,
                            onChanged: (val) {
                              // Handle email input
                              if (_debounce?.isActive ?? false) _debounce?.cancel();
                              _debounce = Timer(Duration(milliseconds: 500), () {
                                setState(() {
                                  email = val;
                                });
                              });
                            },
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Lozinka',
                              prefixIcon: Icon(Icons.lock), // Add lock icon
                            ),
                            validator: (val) =>
                                val!.length < 6 ? 'Unesi lozinku koja ima 6+ karaktera' : null,
                            obscureText: true,
                            onChanged: (val) {
                              // Handle password input
                              if (_debounce?.isActive ?? false) _debounce?.cancel();
                              _debounce = Timer(Duration(milliseconds: 500), () {
                                setState(() {
                                  password = val;
                                });
                              });
                            },
                          ),
                          SizedBox(height: 30.0),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState?.validate() ?? false) {
                                  setState(() => loading = true);
                                  dynamic result = await _auth.signInWithEmailPassword(email, password);

                                  if (result == null) {
                                    setState(() {
                                      error = 'Could not sign in with those credentials';
                                      setState(() => loading = false);
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
                ),
              ],
            ),
          );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
