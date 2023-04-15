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
}
