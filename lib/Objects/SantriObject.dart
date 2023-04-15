import 'package:cloud_firestore/cloud_firestore.dart';

class SantriObject {
  String id;
  String absenNgaji;
  String alamat;
  String jenisKelamin;
  String jenjangPendidikan;
  String kamar;
  String kelas;
  String kelasNgaji;
  String kotaAsal;
  bool lunasSPP;
  String nama;
  String namaWali;
  String noHP;
  String pathFotoProfil;
  String pembayaranTerakhir;
  String statusAktif;
  String statusKehadiran;
  String tglLahir;
  Timestamp tglMasuk;
  String unitSekolah;
  Map<String, dynamic> statusKesehatan;
  Map<String, dynamic> statusKepulangan;

  SantriObject({
    required this.id,
    required this.absenNgaji,
    required this.alamat,
    required this.jenisKelamin,
    required this.jenjangPendidikan,
    required this.kamar,
    required this.kelas,
    required this.kelasNgaji,
    required this.kotaAsal,
    required this.lunasSPP,
    required this.nama,
    required this.namaWali,
    required this.noHP,
    required this.pathFotoProfil,
    required this.pembayaranTerakhir,
    required this.statusAktif,
    required this.statusKehadiran,
    required this.tglLahir,
    required this.tglMasuk,
    required this.unitSekolah,
    required this.statusKesehatan,
    required this.statusKepulangan,
  });
}
