import 'package:cloud_firestore/cloud_firestore.dart';

class KelasNgajiObject {
  String id;
  List<dynamic> alfa;
  List<dynamic> hadir;
  String imagePath;
  List<dynamic> izin;
  String kelasNgaji;
  String kodeAsrama;
  String pengabsen;
  List<dynamic> sakit;
  Timestamp timestamp;
  bool adaAbsensi;

  KelasNgajiObject({
    required this.id,
    required this.adaAbsensi,
    required this.alfa,
    required this.hadir,
    required this.imagePath,
    required this.izin,
    required this.kelasNgaji,
    required this.kodeAsrama,
    required this.pengabsen,
    required this.sakit,
    required this.timestamp,
  });
}
