import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esantren_insights_v1/Objects/DataHomePageObject.dart';

class DataHomePageClass {
  static DataHomePageObject getDataHomePage(QuerySnapshot snapshot) {
    int jumlahSantriAktif = 0;
    int jumlahSantriAda = 0;
    int jumlahSantriIzin = 0;
    int jumlahSantriSakit = 0;
    int jumlahSantriHadirNgaji = 0;
    int jumlahLunasSPP = 0;

    snapshot.docs.forEach((DocumentSnapshot document) {
      // print(document.data());
      jumlahSantriAktif++;
      if (document['statusKehadiran'] == 'Ada' ||
          document['statusKehadiran'] == 'Hadir') {
        jumlahSantriAda++;
      } else if (document['statusKehadiran'] == 'Izin' ||
          document['statusKehadiran'] == 'Pulang') {
        jumlahSantriIzin++;
      } else if (document['statusKehadiran'] == 'Sakit') {
        jumlahSantriSakit++;
      } else {
        print('Aneh ${document['statusKehadiran']}');
      }

      try {
        if (document['absenNgaji'] == 'Hadir') {
          jumlahSantriHadirNgaji++;
        }
      } catch (e) {
        print(e);
      }

      if (document['lunasSPP'] == true) {
        jumlahLunasSPP++;
      }
    });

    DataHomePageObject dataHomePageObject = DataHomePageObject(
      jumlahSantriAktif: jumlahSantriAktif,
      jumlahSantriAda: jumlahSantriAda,
      jumlahSantriIzin: jumlahSantriIzin,
      jumlahSantriSakit: jumlahSantriSakit,
      jumlahSantriHadirNgaji: jumlahSantriHadirNgaji,
      jumlahLunasSPP: jumlahLunasSPP,
    );

    return dataHomePageObject;
  }
}
