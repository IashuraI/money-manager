import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/goal_model.dart';

class GoalModelRepository {
  late final CollectionReference<Map<String, dynamic>> _collectionReference;

  GoalModelRepository(){
    _collectionReference = FirebaseFirestore.instance.collection("Goals");
  }

  Future create(GoalModel model) async {
    await _collectionReference.add(model.toJson());
  }

  Stream<Iterable<GoalModel>> get() {
    return _collectionReference
      .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots()
      .map((event) => event.docs.map((doc) => GoalModel.fromSnapshot(doc)));
  }

  Future<void> delete({required String documentId}) async {
    try {
      await _collectionReference.doc(documentId).delete();
    } catch (e) {
    }
  }
}