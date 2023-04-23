import 'package:cloud_firestore/cloud_firestore.dart';

import '../Objects/AsramaObject.dart';

class AsramaClass {
  static Future<AsramaObject> getAsramaDetail(String kodeAsrama) async {
    //query data from a firebase document where kodeAsrama = kodeAsrama
    FirebaseFirestore db = FirebaseFirestore.instance;
    AsramaObject asramaDetail = AsramaObject(
      listFoto: [],
        kelasNgaji: [],
        id: 'id',
        pengasuh: ['a', 'b'],
        didirikanPada: 2000,
        lokasiGeografis: 'lokasiGeografis',
        namaAsrama: 'namaAsrama',
        pathFotoAsrama: 'pathFotoAsrama',
        profilSingkat: 'profilSingkat',
        program: ['a']);

    await db
        .collection("AktivitasCollection")
        .doc(kodeAsrama)
        .get()
        .then((value) {
      String id = value.id;
      String namaAsrama = value.get("namaAsrama").toString();
      List<dynamic> pengasuh = value.get("Pengasuh");
      int didirikanPada = value.get("didirikanPada");
      String lokasiGeografis = value.get("lokasi_geografis").toString();
      String profilSingkat = value.get("profilSingkat").toString();
      String pathFotoAsrama = value.get("pathFotoAsrama").toString();
      List<dynamic> program = value.get("program");
      List<dynamic> kelasNgaji = value.get("kelasNgaji");
      List<dynamic> listFoto = value.get("listFoto");
      asramaDetail = AsramaObject(
          id: id,
          namaAsrama: namaAsrama,
          pengasuh: pengasuh,
          didirikanPada: didirikanPada,
          lokasiGeografis: lokasiGeografis,
          profilSingkat: profilSingkat,
          pathFotoAsrama: pathFotoAsrama,
          kelasNgaji: kelasNgaji,
          program: program,
      listFoto: listFoto
      );
    });

    return asramaDetail;
  }
}
