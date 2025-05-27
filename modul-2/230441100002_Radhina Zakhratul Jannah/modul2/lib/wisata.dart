import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

// Deklarasi StatefulWidget TambahWisata
class TambahWisata extends StatefulWidget {
  const TambahWisata({super.key});

  @override
  State<TambahWisata> createState() => _TambahWisataState();
}

// State dari TambahWisata
class _TambahWisataState extends State<TambahWisata> {
  // Key untuk validasi form
  final _formKey = GlobalKey<FormState>();

  // Variabel untuk menyimpan gambar dalam bentuk bytes
  Uint8List? _imageBytes;

  // ImagePicker untuk memilih gambar
  final picker = ImagePicker();

  // Variabel untuk menyimpan nilai input dari form
  String? _nama;
  String? _lokasi;
  String? _harga;
  String? _deskripsi;
  String? _jenisWisata;

  // List opsi jenis wisata untuk dropdown
  final List<String> jenisWisataList = [
    'Wisata Alam',
    'Wisata Sejarah',
    'Wisata Keluarga',
    'Wisata Edukasi',
    'Wisata Kuliner',
  ];

  // Fungsi untuk mengambil gambar dari galeri
  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes; // Simpan gambar ke variabel state
      });
    }
  }

  // Fungsi untuk validasi dan submit form
  void _submitForm() {
    // Cek apakah form valid dan gambar sudah dipilih
    if (_formKey.currentState!.validate() && _imageBytes != null) {
      _formKey.currentState!.save(); // Simpan nilai form ke variabel

      // Tampilkan dialog konfirmasi data wisata
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Konfirmasi Data Wisata"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tampilkan gambar jika sudah ada
                  _imageBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(_imageBytes!, height: 150),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 12),
                  // Tampilkan detail input user
                  Text("Nama: $_nama"),
                  Text("Lokasi: $_lokasi"),
                  Text("Jenis: $_jenisWisata"),
                  Text("Harga: $_harga"),
                  Text("Deskripsi:\n$_deskripsi"),
                ],
              ),
            ),
            actions: [
              // Tombol OK untuk kembali ke halaman awal
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                  Navigator.of(context).popUntil((route) => route.isFirst); // Kembali ke halaman home
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } 
    // Jika gambar belum dipilih, tampilkan pesan error
    else if (_imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gambar wajib diunggah."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // Fungsi untuk reset form
  void _resetForm() {
    _formKey.currentState!.reset(); // Reset form input
    setState(() {
      _imageBytes = null; // Kosongkan gambar
      _jenisWisata = null; // Reset dropdown
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar halaman Tambah Wisata
      appBar: AppBar(
        title: const Text("Tambah Wisata"),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Container untuk preview gambar
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _imageBytes == null
                    ? const Center(child: Icon(Icons.image, size: 60, color: Colors.grey))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(_imageBytes!, fit: BoxFit.cover),
                      ),
              ),
              const SizedBox(height: 8),

              // Tombol upload gambar
              ElevatedButton.icon(
                onPressed: _getImage,
                icon: const Icon(Icons.upload),
                label: const Text("Upload Gambar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
              ),

              const SizedBox(height: 12),

              // Text field Nama Wisata
              _buildTextFormField(
                label: "Nama Wisata",
                onSaved: (val) => _nama = val,
                validator: (val) => val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),

              // Text field Lokasi Wisata
              _buildTextFormField(
                label: "Lokasi Wisata",
                onSaved: (val) => _lokasi = val,
                validator: (val) => val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),

              // Dropdown Jenis Wisata
              _buildDropdown(),
              const SizedBox(height: 12),

              // Text field Harga Tiket (hanya angka)
              _buildTextFormField(
                label: "Harga Tiket",
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onSaved: (val) => _harga = val,
                validator: (val) => val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),

              // Text field Deskripsi
              _buildTextFormField(
                label: "Deskripsi",
                maxLines: 3,
                onSaved: (val) => _deskripsi = val,
                validator: (val) => val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 20),

              // Tombol Simpan
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(40),
                ),
                child: const Text("Simpan"),
              ),
              const SizedBox(height: 8),

              // Tombol Reset
              TextButton(
                onPressed: _resetForm,
                child: const Text(
                  "Reset",
                  style: TextStyle(color: Colors.indigo),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method untuk membuat TextFormField
  Widget _buildTextFormField({
    required String label,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      validator: validator,
      onSaved: onSaved,
      inputFormatters: inputFormatters,
    );
  }

  // Helper method untuk membuat Dropdown jenis wisata
  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _jenisWisata,
      decoration: InputDecoration(
        labelText: "Jenis Wisata",
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      isExpanded: true,
      items: jenisWisataList.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (val) {
        setState(() {
          _jenisWisata = val!; // Update pilihan jenis wisata
        });
      },
      onSaved: (val) => _jenisWisata = val, // Simpan saat form disubmit
      validator: (val) => val == null ? "Pilih salah satu jenis wisata" : null,
    );
  }
}

