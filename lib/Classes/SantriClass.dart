import 'package:cloud_firestore/cloud_firestore.dart';

import '../Objects/SantriObject.dart';

class SantriClass {
  static List<SantriObject> getSantriList(QuerySnapshot snapshot) {
    List<SantriObject> allSantriList = [];

    //check if the document
    snapshot.docs.forEach((data1) {
      Map data_map = data1.data() as Map<String, dynamic>;
      SantriObject santriObject = SantriObject(
        absenNgaji: data_map['absenNgaji'] ?? "Alfa",
        alamat: data_map['alamat'] ?? "",
        jenisKelamin: data_map['jenisKelamin'] ?? "",
        jenjangPendidikan: data_map['jenjangPendidikan'] ?? "",
        kamar: data_map['kamar'] ?? "",
        kelas: data_map['kelas'] ?? "",
        kelasNgaji: data_map['kelasNgaji'] ?? "",
        kotaAsal: data_map['kotaAsal'] ?? "",
        lunasSPP: data_map['lunasSPP'] ?? false,
        nama: data_map['nama'] ?? "",
        namaWali: data_map['namaWali'] ?? "",
        noHP: data_map['noHP'] ?? "",
        pathFotoProfil: data_map['pathFotoProfil'] ?? "",
        pembayaranTerakhir: data_map['pembayaranTerakhir'] ?? "",
        statusAktif: data_map['statusAktif'] ?? "",
        statusKehadiran: data_map['statusKehadiran'] ?? "",
        tglLahir: data_map['tglLahir'] ?? "",
        tglMasuk: data_map['tglMasuk'].toDate(),
        unitSekolah: data_map['unitSekolah'] ?? "",
      );

      allSantriList.add(santriObject);
    });
    return allSantriList;
  }
}
