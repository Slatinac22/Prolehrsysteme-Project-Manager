// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:project_manager/screens/home/settings_form.dart';
import 'package:project_manager/services/auth.dart';
import 'package:project_manager/services/database.dart';
import 'package:provider/provider.dart';
import 'package:project_manager/screens/home/brew_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_manager/models/brew.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

void _showSettingsPanel() {
  showModalBottomSheet(
    context: context,
    builder: (context) { // Add arrow function syntax here
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20), // Fix typo: change 'Border' to 'symmetric'
        child: SettingsForm(),
      );
    }, // Add closing parentheses for the builder parameter
  );
}



    final user = Provider.of<User?>(context);
    return StreamProvider<List<Brew>>.value(
      value: DatabaseService(uid: user?.uid).brews,
      initialData: [], // Provide an empty list as initial data
      child: Scaffold(
        backgroundColor: Colors.purple[50],
        appBar: AppBar(
          title: Text('Project Manager'),
          backgroundColor: Colors.purple[400],
          actions: <Widget>[
            ElevatedButton.icon(
              icon: Icon(Icons.person),
              label: Text('Logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.settings),
              label: Text('settings'),
              onPressed: () => _showSettingsPanel(),
            )
          ],
        ),
        body: BrewList(),
      ),
    );
  }
}

