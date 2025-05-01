import 'package:flutter/material.dart';
import 'package:praktikum1/detail.dart';
import 'package:praktikum1/home.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(), 
      routes: {
        '/home': (context) => HomePage(),
        '/detail': (context) => DetailPage(title: 'DetailPage',),
      },
    ),
  );
}

