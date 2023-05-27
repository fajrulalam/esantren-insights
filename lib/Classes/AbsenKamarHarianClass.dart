import 'package:cloud_firestore/cloud_firestore.dart';

import '../Objects/AbsenKamarHarianObject.dart';

class AbsenKamarHarianClass {
  static List<AbsenKamarHarianObject> getAbsenKelasHariIni(
      QuerySnapshot snapshot) {
    List<AbsenKamarHarianObject> absenKelasHariIni = [];

    snapshot.docs.forEach((element) {
      String idPengabsen = element['idPengabsen'];
      String kelasTingkat = element['kelasTingkat'];
      String kodeAsrama = element['kodeAsrama'];
      String pengabsen = element['pengabsen'];
      Timestamp timestamp = element['timestamp'];

      absenKelasHariIni.add(AbsenKamarHarianObject(
          idPengabsen: idPengabsen,
          kelasTingkat: kelasTingkat,
          kodeAsrama: kodeAsrama,
          pengabsen: pengabsen,
          timestamp: timestamp));
    });

    return absenKelasHariIni;
  }
}
