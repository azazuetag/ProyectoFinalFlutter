import 'package:flutter/material.dart';
import 'package:firebase_login_flutter/root_page.dart';
import 'package:firebase_login_flutter/auth.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'TecNM Roque Acceso',
      theme: new ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: new RootPage(auth: new Auth()),
    );
  }
}
