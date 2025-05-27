import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class GambarDenganLokasi {
  final dynamic image;
  final double latitude;
  final double longitude;
  final String alamat;

  GambarDenganLokasi({
    required this.image,
    required this.latitude,
    required this.longitude,
    required this.alamat,
  });
}

class SaveImagePage extends StatefulWidget {
  const SaveImagePage({super.key});

  @override
  State<SaveImagePage> createState() => _SaveImagePageState();
}

class _SaveImagePageState extends State<SaveImagePage> {
  final List<GambarDenganLokasi> _dataGambar = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _ambilGambar(ImageSource sumber) async {
    final izinGambar = await Permission.camera.request();
    final izinPenyimpanan = await Permission.photos.request();
    final izinLokasi = await Geolocator.requestPermission();

    if (!izinGambar.isGranted ||
        !izinPenyimpanan.isGranted ||
        izinLokasi == LocationPermission.denied ||
        izinLokasi == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Izin tidak lengkap!')));
      return;
    }

    final XFile? file = await _picker.pickImage(source: sumber);
    if (file == null) return;

    Uint8List imageBytes = await file.readAsBytes();

    await ImageGallerySaverPlus.saveImage(
      imageBytes,
      quality: 100,
      name: 'gambar_${DateTime.now().millisecondsSinceEpoch}',
    );

    Position posisi = await Geolocator.getCurrentPosition();

    String alamat = '';
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        posisi.latitude,
        posisi.longitude,
      );

      if (placemarks.isNotEmpty) {
        alamat =
            '${placemarks.first.street ?? ''}, '
            '${placemarks.first.locality ?? ''}, '
            '${placemarks.first.administrativeArea ?? ''}';
      } else {
        alamat = 'Alamat tidak ditemukan';
      }
    } catch (e) {
      alamat = 'Gagal mengambil alamat';
    }

    setState(() {
      _dataGambar.add(
        GambarDenganLokasi(
          image: kIsWeb ? imageBytes : File(file.path),
          latitude: posisi.latitude,
          longitude: posisi.longitude,
          alamat: alamat,
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gambar dan lokasi berhasil disimpan!')),
    );
  }

  Future<void> _cekKoneksi() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada koneksi jaringan ❌')),
      );
      return;
    }

    // Kalau ada koneksi jaringan, cek apakah internet benar-benar aktif
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Internet aktif ✅')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak ada koneksi internet ❌')),
        );
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada koneksi internet ❌')),
      );
    }
  }

  Widget _tampilkanGambar() {
    if (_dataGambar.isEmpty) {
      return const Center(child: Text('Belum ada gambar yang diambil.'));
    }

    return ListView.builder(
      itemCount: _dataGambar.length,
      itemBuilder: (context, index) {
        final item = _dataGambar[index];
        final widgetGambar =
            kIsWeb
                ? Image.memory(
                  item.image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                : Image.file(
                  item.image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widgetGambar,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Koordinat: ${item.latitude.toStringAsFixed(5)}, ${item.longitude.toStringAsFixed(5)}',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Alamat: ${item.alamat}'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gambar + Lokasi + Galeri + Notifikasi"),
      ),
      body: _tampilkanGambar(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'kamera',
            onPressed: () => _ambilGambar(ImageSource.camera),
            tooltip: 'Ambil dari Kamera',
            child: const Icon(Icons.camera_alt),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'galeri',
            onPressed: () => _ambilGambar(ImageSource.gallery),
            tooltip: 'Ambil dari Galeri',
            child: const Icon(Icons.photo_library),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'koneksi',
            onPressed: _cekKoneksi,
            tooltip: 'Cek Koneksi Internet',
            child: const Icon(Icons.wifi),
          ),
        ],
      ),
    );
  }
}
