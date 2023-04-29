import 'package:cloud_firestore/cloud_firestore.dart';

class PengumumanObject {
  String? id;
  String judul;
  String isi;
  Timestamp timestamp;
  String gambar;
  String file;

  PengumumanObject({
    this.id,
    required this.judul,
    required this.isi,
    required this.timestamp,
    required this.gambar,
    required this.file,
  });

  Map<String, dynamic> toJson() {
    return {
      'judul': judul,
      'isi': isi,
      'timestamp': timestamp,
      'gambar': gambar,
      'file': file,
    };
  }
}
