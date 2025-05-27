import 'package:flutter/material.dart';
import 'package:tutorbutnav/services/lagu_service.dart';
import '../models/lagu.dart';

class LaguScreen extends StatefulWidget {
  const LaguScreen({super.key});

  @override
  State<LaguScreen> createState() => _LaguScreenState();
}

class _LaguScreenState extends State<LaguScreen> {
  late Future<List<Lagu>> futureLagu;

  @override
  void initState() {
    super.initState();
    futureLagu = LaguService.fetchLagu();
  }

  void _refreshData() {
    setState(() {
      futureLagu = LaguService.fetchLagu();
    });
  }

  void _showEditDialog(Lagu lagu) {
    final genreController = TextEditingController(text: lagu.genre);
    final judulController = TextEditingController(text: lagu.judul);
    final penyanyiController = TextEditingController(text: lagu.penyanyi);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Lagu'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: genreController,
                  decoration: const InputDecoration(labelText: 'Genre'),
                ),
                TextField(
                  controller: judulController,
                  decoration: const InputDecoration(labelText: 'Judul Lagu'),
                ),
                TextField(
                  controller: penyanyiController,
                  decoration: const InputDecoration(labelText: 'Penyanyi'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedLagu = Lagu(
                  id: lagu.id, // ID tetap sesuai yang di Firebase
                  genre: genreController.text,
                  judul: judulController.text,
                  penyanyi: penyanyiController.text,
                );
                await LaguService.updateLagu(updatedLagu);
                Navigator.pop(context);
                _refreshData();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showAddDialog() {
    final genreController = TextEditingController();
    final judulController = TextEditingController();
    final penyanyiController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Lagu'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: genreController,
                  decoration: const InputDecoration(labelText: 'Genre'),
                ),
                TextField(
                  controller: judulController,
                  decoration: const InputDecoration(labelText: 'Judul'),
                ),
                TextField(
                  controller: penyanyiController,
                  decoration: const InputDecoration(labelText: 'Penyanyi'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newLagu = Lagu(
                  id: '', // kosong aja karena ID auto generate
                  genre: genreController.text,
                  judul: judulController.text,
                  penyanyi: penyanyiController.text,
                );
                await LaguService.addLagu(newLagu);
                Navigator.pop(context);
                _refreshData(); // refresh list setelah dialog ditutup
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 166, 0, 181),
        centerTitle: true,
        title: const Text(
          'Metadata Lagu',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<Lagu>>(
        future: futureLagu,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi Kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data'));
          } else {
            final laguList = snapshot.data!;
            return ListView.builder(
              itemCount: laguList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(laguList[index].genre),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        laguList[index].judul,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(laguList[index].penyanyi),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditDialog(laguList[index]);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await LaguService.deleteLagu(laguList[index].id);
                          _refreshData();
                        },
                      ),
                    ],
                  ),
                  onTap: () => _showEditDialog(laguList[index]),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: const Color.fromARGB(255, 166, 0, 181),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white, // warna icon jadi putih
        ),
      ),
    );
  }
}
