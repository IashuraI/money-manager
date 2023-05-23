import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/transaction_model.dart';

class TransactionModelRepository {
  late final CollectionReference<Map<String, dynamic>> _collectionReference;

  TransactionModelRepository(){
    _collectionReference = FirebaseFirestore.instance.collection("Transactions");
  }

  Future create(TransactionModel model) async {
    await _collectionReference.add(model.toJson());
  }

  Stream<Iterable<TransactionModel>> get() {
    return _collectionReference
      .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .orderBy("date", descending: true)
      .snapshots()
      .map((event) => event.docs.map((doc) => TransactionModel.fromSnapshot(doc)));
  }

  Future<bool> update({required String documentId, required Map<String, String?> entity}) async {
    bool result = true;

    await _collectionReference .doc(documentId)
      .update(entity).catchError((error) => result == false);

    return result;
  }

  Future<void> delete({required String documentId}) async {
    try {
      await _collectionReference.doc(documentId).delete();
    } catch (e) {
    }
  }
}