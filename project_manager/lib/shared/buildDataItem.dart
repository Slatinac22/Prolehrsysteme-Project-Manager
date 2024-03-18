import 'package:flutter/material.dart';
import 'package:project_manager/shared/colors.dart'; 



 Widget buildDataItem(String title, String data) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.dataItemColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(10, 10),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            data,
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
        ],
      ),
    );
  }
