import 'package:cloud_firestore/cloud_firestore.dart';

class PelunasanObject {
  String id;
  String nama;
  int jumlahTanggungan;
  List<String> daftarInvoiceBelumLunas;

  PelunasanObject({
    required this.id,
    required this.nama,
    required this.jumlahTanggungan,
    required this.daftarInvoiceBelumLunas,
  });
}

class InvoiceObject {
  Timestamp tglInvoice;
  String idInvoice;
  int nominal;

  InvoiceObject({
    required this.tglInvoice,
    required this.idInvoice,
    required this.nominal,
  });
}
