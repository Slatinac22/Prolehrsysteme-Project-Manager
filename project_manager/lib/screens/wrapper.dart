import 'package:flutter/material.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/screens/authenticate/authenticate.dart';
import 'package:project_manager/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {


    final user = Provider.of<HandmadeUser?>(context);


      //return either home or authenticate
      if(user == null){
        return Authenticate();
      }
      else{
        return Home();
      }


  }
}