import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esantren_insights_v1/Objects/CurrentUserObject.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Services/Authentication.dart';

class CurrentUserClass {
  final User? user = Auth().currentUser;

  Future<CurrentUserObject> getUserDetail() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    late CurrentUserObject currrentUserObject;

    await db
        .collection("PengurusCollection")
        .doc(user?.uid)
        .get()
        .then((value) {
      String namaLengkap = value.get("namaLengkap").toString();
      String namaPanggilan = value.get("namaPanggilan").toString();
      String honoraryName = value.get("honoraryName").toString();
      String jenisKelamin = value.get("jenisKelamin").toString();
      String kotaAsal = value.get("kotaAsal").toString();
      String tglLahir = value.get("tglLahir").toString();
      String mukim_str = value.get("mukim").toString();
      String fotoProfil = value.get("fotoProfil").toString();
      String role = value.get("role").toString();
      String kodeAsrama = value.get("kodeAsrama").toString();
      bool mukim = mukim_str == 'true';
      List<dynamic> mengajarKelas = value.get("mengajarKelas");
      currrentUserObject = CurrentUserObject(
          uid: user?.uid,
          honoraryName: honoraryName,
          fotoProfil: fotoProfil,
          namaLengkap: namaLengkap,
          namaPanggilan: namaPanggilan,
          jenisKelamin: jenisKelamin,
          kodeAsrama: kodeAsrama,
          kotaAsal: kotaAsal,
          tglLahir: tglLahir,
          role: role,
          mukim: mukim,
          mengajarKelas: mengajarKelas);
      print('Berhasil mendapatkan $namaPanggilan');
    });

    return currrentUserObject;
  }
}
