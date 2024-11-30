import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:appdesign/app/auth/login.dart';
import 'package:appdesign/app/auth/signup.dart';
import 'package:appdesign/app/auth/success.dart';
import 'package:appdesign/app/home.dart';
import 'package:appdesign/app/notes/add.dart';
import 'package:appdesign/app/notes/edit.dart';

late SharedPreferences sharedPref;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        initialRoute: sharedPref.getString("id") == null ? 'login' : 'home',
        routes: {
          'login': (context) => Login(),
          'signup': (context) => Signup(),
          'home': (context) => Home(),
          'success': (context) => Success(),
          'addnotes': (context) => AddNotes(),
          'editnotes': (context) => EditNotes(),
        });
  }
}
