// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:project_manager/screens/home/brew_tile.dart';
import 'package:provider/provider.dart';
import 'package:project_manager/models/brew.dart';


class BrewList extends StatefulWidget {
  const BrewList({super.key});

  @override
  State<BrewList> createState() => _BrewListState();
}

class _BrewListState extends State<BrewList> {
  @override
  Widget build(BuildContext context) {

      final brews = Provider.of<List<Brew>>(context);





    return ListView.builder(
      itemCount: brews.length,
      itemBuilder: (context, index) {
        return BrewTile(brew: brews[index]);
      } ,
    );
  }
}
