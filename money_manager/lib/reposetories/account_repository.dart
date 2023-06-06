import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/account_model.dart';

class AccountModelRepository {
  late final CollectionReference<Map<String, dynamic>> _collectionReference;

  AccountModelRepository(){
    _collectionReference = FirebaseFirestore.instance.collection("Accounts");
  }

  Future create(AccountModel model) async {
    await _collectionReference.add(model.toJson());
  }

  Stream<Iterable<AccountModel>> get() {
    return _collectionReference
      .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots()
      .map((event) => event.docs.map((doc) => AccountModel.fromSnapshot(doc)));
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