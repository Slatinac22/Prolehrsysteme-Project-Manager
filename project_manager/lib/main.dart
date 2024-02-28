// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/screens/wrapper.dart';
import 'package:project_manager/services/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAVpcN6MdTONJ7YqKqROjPWRM4R0WwoNos",
      appId: "1:1019738645122:web:e0edcbffa7ce9f646e0a9b",
      messagingSenderId: "1019738645122",
      projectId: "prolehrsysteme-project-m-c7547",
    ),
  );

  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<HandmadeUser?>.value(
      value: AuthService().user, // Accepts nullable HandmadeUser
      initialData: null, // You can provide initial data here if needed
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Set debugShowCheckedModeBanner to false
        home: Wrapper(),
      ),
    );
  }
}