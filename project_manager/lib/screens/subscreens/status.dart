import 'package:flutter/material.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
       return Scaffold(
      appBar: AppBar(
        title: Text('Status'),
      ),
      body: Center(
        child: Text('Placeholder for StatusPage '),
      ),
    );
  }
}