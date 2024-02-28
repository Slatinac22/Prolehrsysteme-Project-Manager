// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:js_interop';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/services/database.dart';
import 'package:project_manager/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {


  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0','1','2','3','4'];

  String _currentName='';
  String _currentSugars='';
  int _currentStrength = 0;


  @override
  Widget build(BuildContext context) {

  final user = Provider.of<HandmadeUser>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){

          UserData userData = snapshot.data!;

          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'Update your brew settings.',
                  style:TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: textInputDecoration,
                  validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) => setState(() {
                    _currentName = val;
                  }),
                ),
                SizedBox(height:20),
                //dropdown
                DropdownButtonFormField(
                  decoration: textInputDecoration,
                  value: _currentSugars.isNotEmpty ? _currentSugars : sugars[0],
                  items: sugars.map((sugar) {
                    return DropdownMenuItem(
                      value: sugar,
                      child: Text('$sugar sugars'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() => _currentSugars = val.toString());
                  },
                ),
                Slider(
                  value: (_currentStrength ?? 100).toDouble(),
                  activeColor: Colors.purple[_currentStrength ?? 100],
                  inactiveColor: Colors.purple[_currentStrength ?? 100],
                  min: 0,
                  max: 900,
                  divisions: 8,
                  onChanged: (val) {
                    setState(() {
                      _currentStrength = val.round();
                    });
                  },
                ),
          
                //slider
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                
                  child:Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      await DatabaseService(uid: user.uid).updateUserData(
                        _currentSugars ?? userData.sugars,
                        _currentName ?? userData.name,
                        _currentStrength ?? userData.strength,
                      );
                      Navigator.pop(context);
                    }
                  },
                )
          
          
              ],
            ),
        );
        }
        else{
        return Container(); // Or SizedBox()
        }
       
      }
    );
  }
}