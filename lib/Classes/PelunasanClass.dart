import 'package:cloud_firestore/cloud_firestore.dart';

import '../Objects/PelunasanObject.dart';
import '../Objects/SantriObject.dart';

class PelunasanClass {
  static Future<List<PelunasanObject>> getDaftarPelunasan(
      List<SantriObject> listSantriBelumLunas) async {
    List<PelunasanObject> daftarPelunasan =
        []; //ini nanti yang tampil di ListView

    List<InvoiceObject> daftarInvoiceLengkap =
        []; //ini daftar tagihan lengkap dari asrama

    List<String> bulanYangSudahDilunasi = [];

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("InvoiceCollection").get();

    querySnapshot.docs.forEach((document) {
      InvoiceObject invoiceObject = InvoiceObject(
          idInvoice: document.id,
          nominal: document['nominal'],
          tglInvoice: document['tglInvoice']);
      daftarInvoiceLengkap.add(invoiceObject);
    });

    for (SantriObject santri in listSantriBelumLunas) {
      Timestamp tglMasuk = santri.tglMasuk;
      bulanYangSudahDilunasi = [];
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("SantriCollection")
          .doc(santri.id)
          .collection("PembayaranCollection")
          .get();

      querySnapshot.docs.forEach((element) {
        String namaPembayaran = element['namaPembayaran'];
        // Timestamp tglMasuk = element['tglMasuk'];
        bool exsts = false;

        bulanYangSudahDilunasi.add(namaPembayaran);
      });

      Iterable<InvoiceObject> daftarInvoiceSejakSantriMasuk =
          daftarInvoiceLengkap.where((element) =>
              element.tglInvoice.millisecondsSinceEpoch >
              tglMasuk.millisecondsSinceEpoch);

      int countBelumLunas = 0;
      List<String> daftarInvoiceBelumLunas = [];
      for (InvoiceObject invoice in daftarInvoiceSejakSantriMasuk) {
        if (!bulanYangSudahDilunasi.contains(invoice.idInvoice)) {
          print('${santri.nama} BELUM MELUNASI ${invoice.idInvoice}');
          countBelumLunas++;
          daftarInvoiceBelumLunas.add(invoice.idInvoice);
        } else {
          print('${santri.nama} SUDAH MELUNASI ${invoice.idInvoice}');
        }
      }

      PelunasanObject pelunasanObject = PelunasanObject(
          id: santri.id,
          nama: santri.nama,
          jumlahTanggungan: countBelumLunas,
          daftarInvoiceBelumLunas: daftarInvoiceBelumLunas);

      daftarPelunasan.add(pelunasanObject);
    }

    return daftarPelunasan;
  }
}
