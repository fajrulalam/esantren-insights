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
  String idPengabsen;
  List<dynamic> sakit;
  Timestamp timestamp;
  Timestamp? timestampSelesai;
  bool adaAbsensi;
  int? berapaKaliAbsen;
  num? totalDurationInSeconds;

  KelasNgajiObject(
      {required this.id,
      required this.adaAbsensi,
      required this.alfa,
      required this.hadir,
      required this.imagePath,
      required this.izin,
      required this.kelasNgaji,
      required this.kodeAsrama,
      required this.pengabsen,
      required this.idPengabsen,
      required this.sakit,
      required this.timestamp,
      this.timestampSelesai,
      this.berapaKaliAbsen,
      this.totalDurationInSeconds});
}
