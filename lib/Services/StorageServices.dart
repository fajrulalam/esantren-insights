import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esantren_insights_v1/Objects/CurrentUserObject.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import 'package:firebase_core/firebase_core.dart';

class StorageServices {
  static Future<String> uploadProfileImage(
      XFile imageFile, String currentUID) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    String snapshotURL = '';
    String fileName = basename(imageFile.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref('/fotoProfilPengurus/$fileName');
    UploadTask uploadTask;

    if (kIsWeb) {
      print('its in the web');
      Uint8List imageData = await imageFile.readAsBytes();
      uploadTask = reference.putData(imageData);
    } else {
      File file = File(imageFile.path);
      uploadTask = reference.putFile(file);
    }

    // TaskSnapshot snapshot = await task.whenComplete(() {snapshotURL = await snapshot.ref.getDownloadURL()});
    TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    snapshotURL = await snapshot.ref.getDownloadURL();

    await db.collection('PengurusCollection').doc(currentUID).update(
      {"fotoProfil": snapshotURL},
    );

    return snapshotURL;
  }

  static Future<String> uploadAbsenImage(XFile imageFile,
      {required CurrentUserObject currentUserObject,
      required String kelasNgaji,
      required String kodeAbsenLogsHariIni}) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    String snapshotURL = '';
    String fileName = basename(imageFile.path);
    //get this current year
    String yearNow = DateFormat('yyyy').format(DateTime.now());
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference =
        storage.ref('/fotoAbsenNgaji/$yearNow/$kelasNgaji/$fileName');
    UploadTask uploadTask;

    if (kIsWeb) {
      print('its in the web');
      Uint8List imageData = await imageFile.readAsBytes();
      uploadTask = reference.putData(imageData);
    } else {
      File file = File(imageFile.path);
      uploadTask = reference.putFile(file);
    }

    // TaskSnapshot snapshot = await task.whenComplete(() {snapshotURL = await snapshot.ref.getDownloadURL()});
    TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    snapshotURL = await snapshot.ref.getDownloadURL();

    db
        .collection('AktivitasCollection')
        .doc(currentUserObject.kodeAsrama)
        .collection('AbsenNgajiLogs')
        .doc(kodeAbsenLogsHariIni)
        .update({
      // 'tanggal': dateNow,
      'imagePath': snapshotURL,
    });

    return snapshotURL;
  }

  static deletePreviousImage(String url) {
    FirebaseStorage.instance.refFromURL(url).delete();
  }

  static Future<String> uploadImagePengumuman(
      XFile imageFile, CurrentUserObject currentUserObject) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    String snapshotURL = '';
    String fileName = basename(imageFile.path);
    //get this current year
    String yearNow = DateFormat('yyyy').format(DateTime.now());
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref(
        '/pengumumanAttachments/${currentUserObject.kodeAsrama}/$fileName');
    UploadTask uploadTask;

    if (kIsWeb) {
      print('its in the web');
      Uint8List imageData = await imageFile.readAsBytes();
      uploadTask = reference.putData(imageData);
    } else {
      File file = File(imageFile.path);
      uploadTask = reference.putFile(file);
    }

    // TaskSnapshot snapshot = await task.whenComplete(() {snapshotURL = await snapshot.ref.getDownloadURL()});
    TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    snapshotURL = await snapshot.ref.getDownloadURL();
    return snapshotURL;
  }
}
