import 'package:cloud_firestore/cloud_firestore.dart';

import '../Objects/PembayaranObject_6BulanTerakhir.dart';

class Pembayaran_6BulanTerakhirClass {
  static Future<List<PembayaranObject_6BulanTerakhir>>
      getPembayaran6BulanTerakhir() async {
    List<PembayaranObject_6BulanTerakhir> chartData = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('InvoiceCollection')
        .where('kodeAsrama', isEqualTo: 'DU15_AlFalah')
        .orderBy('tglInvoice', descending: false)
        .limit(6)
        .get();

    querySnapshot.docs.forEach((document) {
      double jumlahSantriAktif = document['jumlahSantriAktif'].toDouble();
      double jumlahPembayar = document['jumlahPembayar'].toDouble();
      String tglInvoice = document.id.substring(0, 3);
      print(document.data());
      PembayaranObject_6BulanTerakhir pembayaranObject_6BulanTerakhir =
          PembayaranObject_6BulanTerakhir(
              tglInvoice, jumlahSantriAktif, jumlahPembayar);
      chartData.add(pembayaranObject_6BulanTerakhir);
    });

    // List<PembayaranObject_6BulanTerakhir> chartData = [
    //   PembayaranObject_6BulanTerakhir('Nov', 207, 207),
    //   PembayaranObject_6BulanTerakhir('Dec', 207, 207),
    //   PembayaranObject_6BulanTerakhir('Jan', 207, 207),
    //   PembayaranObject_6BulanTerakhir('Feb', 207, 190),
    //   PembayaranObject_6BulanTerakhir('Mar', 207, 176),
    //   PembayaranObject_6BulanTerakhir('Apr', 207, 165),
    // ];

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
