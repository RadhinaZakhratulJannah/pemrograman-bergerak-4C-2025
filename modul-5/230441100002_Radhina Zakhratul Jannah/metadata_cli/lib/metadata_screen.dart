import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MetadataScreen extends StatelessWidget {
  const MetadataScreen({super.key});

  void _showForm(BuildContext context, {DocumentSnapshot? doc}) {
    final isEdit = doc != null;

    final TextEditingController genreController =
        TextEditingController(text: isEdit ? doc['genre'] : '');
    final TextEditingController judulController =
        TextEditingController(text: isEdit ? doc['judul'] : '');
    final TextEditingController penyanyiController =
        TextEditingController(text: isEdit ? doc['penyanyi'] : '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'Edit Metadata' : 'Tambah Metadata'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: genreController,
                decoration: InputDecoration(labelText: 'Genre'),
              ),
              TextField(
                controller: judulController,
                decoration: InputDecoration(labelText: 'Judul'),
              ),
              TextField(
                controller: penyanyiController,
                decoration: InputDecoration(labelText: 'Penyanyi'),
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
              final newData = {
                'genre': genreController.text,
                'judul': judulController.text,
                'penyanyi': penyanyiController.text,
              };

              final collection = FirebaseFirestore.instance.collection('metadata');

              if (isEdit) {
                await collection.doc(doc.id).update(newData);
              } else {
                await collection.add(newData);
              }

              Navigator.pop(context);
            },
            child: Text(isEdit ? 'Simpan Perubahan' : 'Tambah'),
          ),
        ],
      ),
    );
  }

  void _deleteData(BuildContext context, String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus')),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance.collection('metadata').doc(docId).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Metadata Lagu")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('metadata').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Tidak ada data"));
          }

          final data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final lagu = data[index];
              return ListTile(
                title: Text("${lagu['judul']} - ${lagu['genre']}"),
                subtitle: Text(lagu['penyanyi']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () => _showForm(context, doc: lagu),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteData(context, lagu.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
