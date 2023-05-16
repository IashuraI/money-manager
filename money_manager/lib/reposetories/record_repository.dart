import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/record_model.dart';

class RecordModelRepository {
  late final CollectionReference<Map<String, dynamic>> _collectionReference;

  RecordModelRepository(){
    _collectionReference = FirebaseFirestore.instance.collection("Records");
  }

  Future create(RecordModel model) async {
    await _collectionReference.add(model.toJson());
  }

  Stream<Iterable<RecordModel>> get() {
    return _collectionReference
      .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots()
      .map((event) => event.docs.map((doc) => RecordModel.fromSnapshot(doc)));
  }

  Future<void> delete({required String documentId}) async {
    try {
      await _collectionReference.doc(documentId).delete();
    } catch (e) {
    }
  }
}