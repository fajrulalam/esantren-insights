import 'package:cloud_firestore/cloud_firestore.dart';

import '../Objects/PembayaranObject.dart';

class Pembayaran_6BulanTerakhirClass {
  static List<PembayaranObject_6BulanTerakhir> getPembayaran6BulanTerakhir(
      QuerySnapshot snapshot) {
    List<PembayaranObject_6BulanTerakhir> chartData = [];

    for (int i = snapshot.docs.length; i > 0; i--) {
      //this is to get the last 6 monthis
      if (i > snapshot.docs.length - 6) {
        double jumlahSantriAktif =
            snapshot.docs[i - 1]['jumlahSantriAktif'].toDouble();
        double jumlahPembayar =
            snapshot.docs[i - 1]['jumlahPembayar'].toDouble();
        String tglInvoice = snapshot.docs[i - 1].id.substring(0, 3);
        print(snapshot.docs[i - 1].data());
        PembayaranObject_6BulanTerakhir pembayaranObject_6BulanTerakhir =
            PembayaranObject_6BulanTerakhir(
                tglInvoice, jumlahSantriAktif, jumlahPembayar);
        chartData.add(pembayaranObject_6BulanTerakhir);
      }
    }

    return chartData;
  }

  static Future<List<PembayaranObject_6BulanTerakhir>>
      getPembayaranTahunIni() async {
    List<PembayaranObject_6BulanTerakhir> chartData = [];

    Timestamp firstDayOfCurrentYear =
        Timestamp.fromDate(DateTime(DateTime.now().year, 1, 1));

    //get timestamp of current year 1st january

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('InvoiceCollection')
        .where('tglInvoice', isGreaterThan: firstDayOfCurrentYear)
        .orderBy('tglInvoice', descending: false)
        .limit(12)
        .get();

    querySnapshot.docs.forEach((document) {
      double jumlahSantriAktif = document['jumlahSantriAktif'].toDouble();
      double jumlahPembayar = document['jumlahPembayar'].toDouble();
      double nominal = document['nominal'].toDouble();
      String tglInvoice = document.id.substring(0, 3);
      print(document.data());
      PembayaranObject_6BulanTerakhir pembayaranObject_6BulanTerakhir =
          PembayaranObject_6BulanTerakhir(
              tglInvoice, jumlahSantriAktif, jumlahPembayar,
              nominal: nominal);
      chartData.add(pembayaranObject_6BulanTerakhir);
    });
    return chartData;
  }
}
