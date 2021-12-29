import 'package:asi_takip/vaccinesinfo.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './home.dart';
import './add_child.dart';
import 'package:asi_takip/login.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AsiTakipApp());

}


class AsiTakipApp extends StatelessWidget {
  const AsiTakipApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.yellow,
        scaffoldBackgroundColor: const Color.fromRGBO(231, 220, 217, 1.0),
      ),
      home: LoginPage(),
    );
  }
}

//guncelleme
