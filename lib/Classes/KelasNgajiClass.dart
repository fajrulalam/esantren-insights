import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esantren_insights_v1/Objects/KelasNgajiObject.dart';

class KelasNgajiClass {
  static List<KelasNgajiObject> getKelasNgajiDetail(
      QuerySnapshot snapshot, List<dynamic> semuaKelasNgaji) {
    List<KelasNgajiObject> allKelasNgajiList = [];

    for (int i = 0; i < semuaKelasNgaji.length; i++) {
      allKelasNgajiList.add(KelasNgajiObject(
          id: '',
          alfa: [],
          hadir: [],
          imagePath: '',
          izin: [],
          kelasNgaji: semuaKelasNgaji[i],
          kodeAsrama: '',
          pengabsen: '',
          sakit: [],
          adaAbsensi: false,
          timestamp: Timestamp.now()));
    }

    int index;
    for (int i = 0; i < snapshot.docs.length; i++) {
      String id = snapshot.docs[i].id;
      Map map = snapshot.docs[i].data() as Map<String, dynamic>;
      //check at which index the kelasNgaji is in the list
      index = semuaKelasNgaji.indexOf(map['kelasNgaji']);
      if (index == -1) {
        continue;
      }

      allKelasNgajiList[index] = KelasNgajiObject(
          id: id,
          alfa: map['alfa'] ?? [],
          hadir: map['hadir'] ?? [],
          imagePath: map['imagePath'],
          izin: map['izin'] ?? [],
          kelasNgaji: map['kelasNgaji'],
          kodeAsrama: map['kodeAsrama'],
          pengabsen: map['pengabsen'],
          sakit: map['sakit'] ?? [],
          adaAbsensi: true,
          timestamp: map['timestamp']);
    }

    return allKelasNgajiList;
  }
}
