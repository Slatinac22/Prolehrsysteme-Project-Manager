import 'package:flutter/material.dart';
import 'package:project_manager/services/auth.dart';

class Home extends StatelessWidget {
    final AuthService _auth = AuthService();




  @override
  Widget build(BuildContext context) {
      return Scaffold(
        
        backgroundColor: Colors.purple[50],
        appBar: AppBar(
          title: Text('Project Manager'),
          backgroundColor: Colors.purple[400],
          actions: <Widget>[
            ElevatedButton.icon(
              icon:Icon(Icons.person),
              label: Text('Logout'),
              onPressed: () async {
                await _auth.signOut();
              },
                
            )
          ],
        ),
      );
  }
}