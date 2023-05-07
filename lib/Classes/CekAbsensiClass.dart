import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esantren_insights_v1/Objects/CurrentUserObject.dart';
import 'package:esantren_insights_v1/Objects/KelasNgajiObject.dart';
import 'package:esantren_insights_v1/Objects/PengajarObject.dart';

import '../Objects/CekAbsensiObject.dart';

class CekAbsensiClass {
  static Future<CekAbsensiObject> cekAbsensiHarian(
      CurrentUserObject userObject) async {
    List<KelasNgajiObject> dataKelas = [];
    List<PengajarObject> dataPengajar = [];

    //get date time today 00:00
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    Timestamp timestampToday = Timestamp.fromDate(today);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("AktivitasCollection")
        .doc(userObject.kodeAsrama)
        .collection('AbsenNgajiLogs')
        .where('timestamp', isGreaterThan: timestampToday)
        .get();

    List<String> idPengajarListString = [];
    List<String> idKelasListString = [];

    querySnapshot.docs.forEach((element) {
      Map kelasMap = element.data() as Map<String, dynamic>;

      dataKelas.add(KelasNgajiObject(
          id: element.id,
          alfa: kelasMap['alfa'] ?? [],
          hadir: kelasMap['hadir'] ?? [],
          imagePath: kelasMap['imagePath'],
          izin: kelasMap['izin'] ?? [],
          kelasNgaji: kelasMap['kelasNgaji'],
          kodeAsrama: kelasMap['kodeAsrama'],
          pengabsen: kelasMap['pengabsen'],
          idPengabsen: kelasMap['idPengabsen'] ?? '',
          sakit: kelasMap['sakit'] ?? [],
          berapaKaliAbsen: 1,
          adaAbsensi: true,
          timestamp: kelasMap['timestamp'],
          timestampSelesai: kelasMap['timestampSelesai']));
    });

    //loop through all the dataKelas to get the idPengajar
    for (var element in dataKelas) {
      if (!idPengajarListString.contains(element.idPengabsen)) {
        await FirebaseFirestore.instance
            .collection("PengurusCollection")
            .doc(element.idPengabsen)
            .get()
            .then((value) {
          Map mapPengurus = value.data() as Map<String, dynamic>;
          String honoraryName = mapPengurus['honoraryName'];
          String namaLengkap = mapPengurus['namaLengkap'];
          String namaPanggilan = mapPengurus['namaPanggilan'];
          String imagePath = mapPengurus['fotoProfil'];
          bool mukim = mapPengurus['mukim'];

          dataPengajar.add(PengajarObject(
              id: element.idPengabsen,
              honoraryName: honoraryName,
              namaLengkap: namaLengkap,
              namaPanggilan: namaPanggilan,
              imagePath: imagePath,
              mukim: mukim,
              berapaKaliAbsen: 1,
              timestampMulai: element.timestamp,
              timestampSelesai: element.timestampSelesai!));
        });
      }
    }

    CekAbsensiObject cekAbsensiObject =
        CekAbsensiObject(kelasNgajiList: dataKelas, pengajarList: dataPengajar);

    return cekAbsensiObject;
  }

  static Future<CekAbsensiObject> getDataMingguan(
      CurrentUserObject userObject) async {
    CekAbsensiObject cekAbsensiObject =
        CekAbsensiObject(kelasNgajiList: [], pengajarList: []);

    //if today is saturday, then get timestamp today at 00:00
    //else get timestamp last saturday at 00:00
    Timestamp timestampForQuery;
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    Timestamp timestampToday = Timestamp.fromDate(today);
    if (now.weekday == DateTime.saturday) {
      //get timestamp today at 00:00
      print('today is saturday');
      Timestamp timestampToday = Timestamp.fromDate(today);
      timestampForQuery = timestampToday;
      print('timestamp ${timestampToday.seconds}');
    } else {
      //get timestamp last saturday at 00:00
      print('today is not saturday');
      DateTime lastSaturday =
          DateTime(now.year, now.month, now.day - now.weekday - 1);
      Timestamp timestampLastSaturday = Timestamp.fromDate(lastSaturday);
      timestampForQuery = timestampLastSaturday;
      print('timestamp ${timestampLastSaturday.seconds}');
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("AktivitasCollection")
        .doc(userObject.kodeAsrama)
        .collection('AbsenNgajiLogs')
        .where('timestamp', isGreaterThan: timestampForQuery)
        .get();

    List<KelasNgajiObject> dataKelas = [];
    List<String> listStringKelas = [];
    List<String> listStringPengajar = [];
    List<PengajarObject> dataPengajar = [];

    await Future.wait(querySnapshot.docs.map((element) async {
      Map kelasMap = element.data() as Map<String, dynamic>;

      String kelasNgaji = kelasMap['kelasNgaji'];

      if (!listStringKelas.contains(kelasNgaji)) {
        // listStringKelas.add(kelasNgaji);
        //add the detail in datakelas
        dataKelas.add(KelasNgajiObject(
            id: element.id,
            alfa: kelasMap['alfa'] ?? [],
            hadir: kelasMap['hadir'] ?? [],
            imagePath: kelasMap['imagePath'],
            izin: kelasMap['izin'] ?? [],
            kelasNgaji: kelasMap['kelasNgaji'],
            kodeAsrama: kelasMap['kodeAsrama'],
            pengabsen: kelasMap['pengabsen'],
            idPengabsen: kelasMap['idPengabsen'] ?? '',
            sakit: kelasMap['sakit'] ?? [],
            adaAbsensi: true,
            timestamp: kelasMap['timestamp'],
            berapaKaliAbsen: 1,
            totalDurationInSeconds: kelasMap['timestampSelesai'].seconds -
                kelasMap['timestamp'].seconds,
            timestampSelesai: kelasMap['timestampSelesai']));
        print('IF: isi data kelas ${dataKelas.length}');
      } else {
        print('ELSE: isi data kelas ${dataKelas.length}');

        int index = listStringKelas.indexOf(kelasNgaji);
        dataKelas[index].alfa.addAll(kelasMap['alfa'] ?? []);
        dataKelas[index].hadir.addAll(kelasMap['hadir'] ?? []);
        dataKelas[index].izin.addAll(kelasMap['izin'] ?? []);
        dataKelas[index].sakit.addAll(kelasMap['sakit'] ?? []);
        dataKelas[index].berapaKaliAbsen =
            dataKelas[index].berapaKaliAbsen! + 1;
        dataKelas[index].totalDurationInSeconds =
            dataKelas[index].totalDurationInSeconds! +
                (kelasMap['timestampSelesai'].seconds -
                    kelasMap['timestamp'].seconds);
      }

      if (!listStringPengajar.contains(kelasMap['idPengabsen'])) {
        // listStringPengajar.add(kelasMap['idPengabsen']);
        print('masuk sini');

        // DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        //     .collection("PengurusCollection")
        //     .doc(kelasMap['idPengabsen'])
        //     .get();

        final value = await FirebaseFirestore.instance
            .collection("PengurusCollection")
            .doc(kelasMap['idPengabsen'])
            .get();
        Map mapPengurus = value.data() as Map<String, dynamic>;

        String honoraryName = mapPengurus['honoraryName'];
        String namaLengkap = mapPengurus['namaLengkap'];
        String namaPanggilan = mapPengurus['namaPanggilan'];
        String imagePath = mapPengurus['fotoProfil'];
        bool mukim = mapPengurus['mukim'];

        dataPengajar.add(PengajarObject(
          id: kelasMap['idPengabsen'],
          honoraryName: honoraryName,
          namaLengkap: namaLengkap,
          namaPanggilan: namaPanggilan,
          imagePath: imagePath,
          mukim: mukim,
          berapaKaliAbsen: 1,
          timestampMulai: kelasMap['timestamp'],
          timestampSelesai: kelasMap['timestampSelesai']!,
          totalDurationInSeconds: kelasMap['timestampSelesai'].seconds -
              kelasMap['timestamp'].seconds,
        ));
        print('IF: isi data pengajar ${dataPengajar.length}');
      } else {
        print('ELSE: isi data pengajar ${dataPengajar.length}');
        int index = listStringPengajar.indexOf(kelasMap['idPengabsen']);
        dataPengajar[index].berapaKaliAbsen =
            dataPengajar[index].berapaKaliAbsen! + 1;
        dataPengajar[index].totalDurationInSeconds =
            dataPengajar[index].totalDurationInSeconds! +
                (kelasMap['timestampSelesai'].seconds -
                    kelasMap['timestamp'].seconds);
      }
    }));

    cekAbsensiObject =
        CekAbsensiObject(kelasNgajiList: dataKelas, pengajarList: dataPengajar);

    return cekAbsensiObject;
  }

  static Future<CekAbsensiObject> getDataBulanan(
      CurrentUserObject userObject) async {
    CekAbsensiObject cekAbsensiObject =
        CekAbsensiObject(kelasNgajiList: [], pengajarList: []);

    //if today is saturday, then get timestamp today at 00:00
    //else get timestamp last saturday at 00:00
    Timestamp timestampForQuery;
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    Timestamp timestampToday = Timestamp.fromDate(today);

    //get timestamp on the first day of this month at 00:00
    DateTime firstDayOfThisMonth = DateTime(now.year, now.month, 1);
    Timestamp timestampFirstDayOfThisMonth =
        Timestamp.fromDate(firstDayOfThisMonth);
    timestampForQuery = timestampFirstDayOfThisMonth;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("AktivitasCollection")
        .doc(userObject.kodeAsrama)
        .collection('AbsenNgajiLogs')
        .where('timestamp', isGreaterThan: timestampForQuery)
        .get();

    List<KelasNgajiObject> dataKelas = [];
    List<String> listStringKelas = [];
    List<String> listStringPengajar = [];
    List<PengajarObject> dataPengajar = [];

    await Future.wait(querySnapshot.docs.map((element) async {
      Map kelasMap = element.data() as Map<String, dynamic>;

      String kelasNgaji = kelasMap['kelasNgaji'];

      if (!listStringKelas.contains(kelasNgaji)) {
        // listStringKelas.add(kelasNgaji);
        //add the detail in datakelas
        dataKelas.add(KelasNgajiObject(
            id: element.id,
            alfa: kelasMap['alfa'] ?? [],
            hadir: kelasMap['hadir'] ?? [],
            imagePath: kelasMap['imagePath'],
            izin: kelasMap['izin'] ?? [],
            kelasNgaji: kelasMap['kelasNgaji'],
            kodeAsrama: kelasMap['kodeAsrama'],
            pengabsen: kelasMap['pengabsen'],
            idPengabsen: kelasMap['idPengabsen'] ?? '',
            sakit: kelasMap['sakit'] ?? [],
            adaAbsensi: true,
            timestamp: kelasMap['timestamp'],
            berapaKaliAbsen: 1,
            totalDurationInSeconds: kelasMap['timestampSelesai'].seconds -
                kelasMap['timestamp'].seconds,
            timestampSelesai: kelasMap['timestampSelesai']));
        print('IF: isi data kelas ${dataKelas.length}');
      } else {
        print('ELSE: isi data kelas ${dataKelas.length}');

        int index = listStringKelas.indexOf(kelasNgaji);
        dataKelas[index].alfa.addAll(kelasMap['alfa'] ?? []);
        dataKelas[index].hadir.addAll(kelasMap['hadir'] ?? []);
        dataKelas[index].izin.addAll(kelasMap['izin'] ?? []);
        dataKelas[index].sakit.addAll(kelasMap['sakit'] ?? []);
        dataKelas[index].berapaKaliAbsen =
            dataKelas[index].berapaKaliAbsen! + 1;
        dataKelas[index].totalDurationInSeconds =
            dataKelas[index].totalDurationInSeconds! +
                (kelasMap['timestampSelesai'].seconds -
                    kelasMap['timestamp'].seconds);
      }

      if (!listStringPengajar.contains(kelasMap['idPengabsen'])) {
        // listStringPengajar.add(kelasMap['idPengabsen']);
        print('masuk sini');

        // DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        //     .collection("PengurusCollection")
        //     .doc(kelasMap['idPengabsen'])
        //     .get();

        final value = await FirebaseFirestore.instance
            .collection("PengurusCollection")
            .doc(kelasMap['idPengabsen'])
            .get();
        Map mapPengurus = value.data() as Map<String, dynamic>;

        String honoraryName = mapPengurus['honoraryName'];
        String namaLengkap = mapPengurus['namaLengkap'];
        String namaPanggilan = mapPengurus['namaPanggilan'];
        String imagePath = mapPengurus['fotoProfil'];
        bool mukim = mapPengurus['mukim'];

        dataPengajar.add(PengajarObject(
          id: kelasMap['idPengabsen'],
          honoraryName: honoraryName,
          namaLengkap: namaLengkap,
          namaPanggilan: namaPanggilan,
          imagePath: imagePath,
          mukim: mukim,
          berapaKaliAbsen: 1,
          timestampMulai: kelasMap['timestamp'],
          timestampSelesai: kelasMap['timestampSelesai']!,
          totalDurationInSeconds: kelasMap['timestampSelesai'].seconds -
              kelasMap['timestamp'].seconds,
        ));
        print('IF: isi data pengajar ${dataPengajar.length}');
      } else {
        print('ELSE: isi data pengajar ${dataPengajar.length}');
        int index = listStringPengajar.indexOf(kelasMap['idPengabsen']);
        dataPengajar[index].berapaKaliAbsen =
            dataPengajar[index].berapaKaliAbsen! + 1;
        dataPengajar[index].totalDurationInSeconds =
            dataPengajar[index].totalDurationInSeconds! +
                (kelasMap['timestampSelesai'].seconds -
                    kelasMap['timestamp'].seconds);
      }
    }));

    cekAbsensiObject =
        CekAbsensiObject(kelasNgajiList: dataKelas, pengajarList: dataPengajar);

    return cekAbsensiObject;
  }

  static List<KelasNgajiObject> aggregateKelasNgajiObject(
      List<KelasNgajiObject> kelasngajiobjectRaw) {
    List<KelasNgajiObject> kelasNgajiObject = [];

    List<String> kelasNgajiList = [];

    for (var element in kelasngajiobjectRaw) {
      String kelasNgaji = element.kelasNgaji;
      if (kelasNgajiList.contains(kelasNgaji)) {
        int index = kelasNgajiList.indexOf(kelasNgaji);
        kelasNgajiObject[index].alfa.addAll(element.alfa);
        kelasNgajiObject[index].hadir.addAll(element.hadir);
        kelasNgajiObject[index].izin.addAll(element.izin);
        kelasNgajiObject[index].sakit.addAll(element.sakit);
        kelasNgajiObject[index].berapaKaliAbsen =
            kelasNgajiObject[index].berapaKaliAbsen! + 1;
        kelasNgajiObject[index].totalDurationInSeconds =
            kelasNgajiObject[index].totalDurationInSeconds! +
                element.totalDurationInSeconds!;
      } else {
        kelasNgajiList.add(kelasNgaji);
        kelasNgajiObject.add(element);
      }
    }

    return kelasNgajiObject;
  }

  static List<PengajarObject> aggregatePengajarObject(
      List<PengajarObject> pengajarObjectRaw) {
    List<PengajarObject> pengajarObjectList = [];

    List<String> pengajarList = [];

    for (var element in pengajarObjectRaw) {
      String idPengajar = element.id;
      if (pengajarList.contains(idPengajar)) {
        int index = pengajarList.indexOf(idPengajar);
        pengajarObjectList[index].berapaKaliAbsen =
            pengajarObjectList[index].berapaKaliAbsen! + 1;
        pengajarObjectList[index].totalDurationInSeconds =
            pengajarObjectList[index].totalDurationInSeconds! +
                element.totalDurationInSeconds!;
      } else {
        pengajarList.add(idPengajar);
        pengajarObjectList.add(element);
      }
    }

    return pengajarObjectList;
  }

  static Future<List<KelasNgajiObject>> getKelasNgajiList(
      CurrentUserObject userObject, String kelasNgaji) async {
    List<KelasNgajiObject> kelasNgajiList = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("AktivitasCollection")
        .doc(userObject.kodeAsrama)
        .collection('AbsenNgajiLogs')
        .where('kelasNgaji', isEqualTo: kelasNgaji)
        .limit(30)
        .get();

    for (var element in querySnapshot.docs) {
      Map<String, dynamic> kelasMap = element.data() as Map<String, dynamic>;

      kelasNgajiList.add(KelasNgajiObject(
          id: element.id,
          alfa: kelasMap['alfa'] ?? [],
          hadir: kelasMap['hadir'] ?? [],
          imagePath: kelasMap['imagePath'],
          izin: kelasMap['izin'] ?? [],
          kelasNgaji: kelasMap['kelasNgaji'],
          kodeAsrama: kelasMap['kodeAsrama'],
          pengabsen: kelasMap['pengabsen'],
          idPengabsen: kelasMap['idPengabsen'] ?? '',
          sakit: kelasMap['sakit'] ?? [],
          adaAbsensi: true,
          timestamp: kelasMap['timestamp'],
          berapaKaliAbsen: 1,
          totalDurationInSeconds: kelasMap['timestampSelesai'].seconds -
              kelasMap['timestamp'].seconds,
          timestampSelesai: kelasMap['timestampSelesai']));
    }

    return kelasNgajiList;
  }
}
