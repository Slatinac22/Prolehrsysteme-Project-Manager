import 'package:flutter/material.dart';
import 'package:project_manager/shared/colors.dart';

AppBar buildCustomAppBar(String title) {
  return AppBar(
    toolbarHeight: 60,
    backgroundColor: AppColors.secondaryColor,
    centerTitle: true,
    elevation: 10, // Set the elevation here
    title: Padding(
      padding: EdgeInsets.only(right: 50), // Add left padding
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            fontFamily: 'Oswald',
          ),
        ),
      ),
    ),
  );
}
