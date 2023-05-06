import 'package:cloud_firestore/cloud_firestore.dart';

class PengajarObject {
  String id;
  String honoraryName;
  String namaPanggilan;
  String imagePath;
  String namaLengkap;
  bool mukim;
  Timestamp timestampMulai;
  Timestamp timestampSelesai;
  int? berapaKaliAbsen;
  num? totalDurationInSeconds;

  PengajarObject(
      {required this.id,
      required this.honoraryName,
      required this.namaPanggilan,
      required this.imagePath,
      required this.namaLengkap,
      required this.timestampMulai,
      required this.timestampSelesai,
      required this.mukim,
      this.berapaKaliAbsen,
      this.totalDurationInSeconds});
}
