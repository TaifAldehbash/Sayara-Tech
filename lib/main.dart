// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sayaratech/views/carinfo.dart';
import 'package:sayaratech/views/newcar.dart';
import 'package:sayaratech/views/profile.dart';
import 'package:sayaratech/views/registerationauth.dart';
import 'package:sayaratech/views/home.dart';
import 'package:sayaratech/views/signin.dart';
import 'package:sayaratech/views/signinauth.dart';
import 'package:sayaratech/views/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignIn(),
      routes: <String, WidgetBuilder>{
        '/SignIn': (BuildContext context) => SignIn(),
        '/SignUp': (BuildContext context) => SignUp(),
        '/RegisterAuth': (BuildContext context) => Authentication(),
        '/SigninAuth': (BuildContext context) => SignInAuth(),
        '/Home': (BuildContext context) => Home(),
        '/Profile': (BuildContext context) => Profile(),
        '/NewCar': (BuildContext context) => NewCar(),
        '/CarInfo': (BuildContext context) => CarInfo(),
      },
    );
  }
}
