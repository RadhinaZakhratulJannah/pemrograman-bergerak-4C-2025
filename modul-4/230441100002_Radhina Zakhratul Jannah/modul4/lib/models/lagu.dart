class Lagu {
  late final String id;
  final String genre;
  final String judul;
  final String penyanyi;

  Lagu({
    required this.id,
    required this.genre,
    required this.judul,
    required this.penyanyi,
  });

  factory Lagu.fromJson(String id, Map<String, dynamic> json) {
    return Lagu(
      id: id,
      genre: json['genre'],
      judul: json['judul'],
      penyanyi: json['penyanyi'],
    );}}
