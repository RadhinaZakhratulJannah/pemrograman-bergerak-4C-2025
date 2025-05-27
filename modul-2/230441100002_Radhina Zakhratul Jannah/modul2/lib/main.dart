import 'package:flutter/material.dart';
import 'package:modul2/home.dart';
import 'package:modul2/wisata.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(), 
      routes: {
        '/home': (context) => HomePage(),
        '/wisata': (context) => TambahWisata()
      },),);}

