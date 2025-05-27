import 'package:flutter/material.dart';
import 'package:tutorbutnav/screens/lagu_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Metadata Lagu API Praktikum',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LaguScreen(),
    );
  }
  }

