import 'package:cloud_firestore/cloud_firestore.dart';

class AbsenKamarHarianObject {
  String idPengabsen;
  String kelasTingkat;
  String kodeAsrama;
  String pengabsen;
  Timestamp timestamp;

  AbsenKamarHarianObject({
    required this.idPengabsen,
    required this.kelasTingkat,
    required this.kodeAsrama,
    required this.pengabsen,
    required this.timestamp,
  });
}
