import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/lagu.dart';

class LaguService {
  static const String baseUrl =
      'https://metadatalagu-65c26-default-rtdb.firebaseio.com';

  static Future<List<Lagu>> fetchLagu() async {
    final response = await http.get(Uri.parse('$baseUrl/meta.json'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Lagu> laguList = [];
      data.forEach((key, value) {
        laguList.add(Lagu.fromJson(key, value));
      });
      return laguList;
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  static Future<void> addLagu(Lagu lagu) async {
    final response = await http.post(
      Uri.parse('$baseUrl/meta.json'),
      body: json.encode({
        'genre': lagu.genre,
        'judul': lagu.judul,
        'penyanyi': lagu.penyanyi,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal menambahkan lagu');
    }
  }

  static Future<void> updateLagu(Lagu lagu) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/meta/${lagu.id}.json'),
      body: json.encode({
        'genre': lagu.genre,
        'judul': lagu.judul,
        'penyanyi': lagu.penyanyi,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal mengupdate lagu');
    }
  }

  static Future<void> deleteLagu(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/meta/$id.json'));
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus lagu');
    }
  }
}
