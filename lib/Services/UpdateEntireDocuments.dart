import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateEntireDocuments {
  Future<void> updateAllDocuments() async {
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('SantriCollection');

    // Update all documents in the collection
    QuerySnapshot querySnapshot = await collectionRef.get();
    querySnapshot.docs.forEach((doc) async {
      await collectionRef.doc(doc.id).update({'new_field': 'new_value'});
    });
  }

  static Future<int> tambahInvoiceBaru() async {
    final Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('SantriCollection')
        .where('statusAktif', isEqualTo: 'Aktif');

    int jumlahSantriAktif = 0;

    // Update all documents in the collection
    QuerySnapshot querySnapshot = await query.get();
    querySnapshot.docs.forEach((doc) async {
      jumlahSantriAktif++;
      await FirebaseFirestore.instance
          .collection('SantriCollection')
          .doc(doc.id)
          .update({'lunasSPP': false});
    });
    return jumlahSantriAktif;
  }
}
