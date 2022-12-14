import 'package:flutter/material.dart';
import 'package:newapp/f.dart';
import 'package:newapp/fundefining.dart';
import 'package:newapp/nextscreen.dart';
import 'package:newapp/practicescreen.dart';
import 'package:newapp/screenfirst.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
debugShowCheckedModeBanner: false,
        home: funcalling(),
    );
  }
}

