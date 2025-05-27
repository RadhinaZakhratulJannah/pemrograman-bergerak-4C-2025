import 'package:flutter/material.dart';
import 'save_image_page.dart'; // pastikan nama file sesuai dan ada di folder `lib/`

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simpan Gambar dan Lokasi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SaveImagePage(),
    );
  }
}
