import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_manager/models/filter_transaction_model.dart';

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

  Stream<Iterable<TransactionModel>> getbyFilter(FilterTransactionModel filterTransactionModel) {
    Query<Map<String, dynamic>> query = _collectionReference
      .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid);

if(filterTransactionModel.list.isNotEmpty){
      List<String> filters = [];

      for (TransactionType element in filterTransactionModel.list) {
        filters.add(element.toString());
      }

      if(filters.length >= 2){
        query = query.where(Filter.or(Filter("type", isEqualTo: filters[0]), Filter("type", isEqualTo: filters[1]),
         filters.elementAtOrNull(2) != null ?  Filter("type", isEqualTo: filters[2]): null,
         filters.elementAtOrNull(3) != null ?  Filter("type", isEqualTo: filters[2]) : null,
         filters.elementAtOrNull(4) != null ?  Filter("type", isEqualTo: filters[2]) : null));
      }
      else{
        query = query.where("type", isEqualTo: filters[0]);
      }
    }

    if(filterTransactionModel.endDate != null){
      query = query.where(Filter.and(Filter("date", isGreaterThan:Timestamp.fromDate(DateTime(filterTransactionModel.startDate.year, filterTransactionModel.startDate.month, filterTransactionModel.startDate.day))),Filter("date", isLessThanOrEqualTo:DateTime(filterTransactionModel.endDate!.year, filterTransactionModel.endDate!.month, filterTransactionModel.endDate!.day, 23, 59, 59))));
    }
    else{
      query = query.where(Filter.and(Filter("date", isGreaterThanOrEqualTo: DateTime(filterTransactionModel.startDate.year, filterTransactionModel.startDate.month, filterTransactionModel.startDate.day)),Filter("date", isLessThanOrEqualTo:   DateTime(filterTransactionModel.startDate.year, filterTransactionModel.startDate.month, filterTransactionModel.startDate.day, 23, 59, 59))));
    }

    return query
      .orderBy("date", descending: true)
      .snapshots()
      .map((event) => event.docs.map((doc) => TransactionModel.fromSnapshot(doc)));
  }

  Future<bool> update({required String documentId, required Map<String, dynamic> entity}) async {
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