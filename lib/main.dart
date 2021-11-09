import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:greenburma/HomePage.dart';
import 'package:greenburma/LogInPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  RenderErrorBox.backgroundColor = Colors.transparent;
  RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home:  MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  String username = '';

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async
  {
    await Firebase.initializeApp();
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      username = sp.getString('Username')!;
    });
    print(username);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green Burma',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: username==''?LoginPage():HomePage(),
    );
  }
}

