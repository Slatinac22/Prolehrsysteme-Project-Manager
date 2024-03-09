// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';


Widget addProjectInputBox(TextEditingController controller,String labelText){

  return Column(
    children: [
      TextField(
        controller: controller,
        maxLines: null,
        decoration: InputDecoration(
          labelText: labelText,
        ),
      ),
      SizedBox(height: 16),
      ],
  );



}