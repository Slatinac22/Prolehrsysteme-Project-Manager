import 'package:flutter/material.dart';
import 'package:project_manager/models/brew.dart';

class BrewTile extends StatelessWidget {


  final Brew brew;
  BrewTile({required this.brew});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin:EdgeInsets.fromLTRB(20, 6.0, 20, 0),
        child: ListTile(
         leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.purple[brew.strength],
        ),
        title: Text(brew.name),
        subtitle: Text('Takes${brew.sugars} sugar(s)'),
       ),
      ),

    );
  }
}