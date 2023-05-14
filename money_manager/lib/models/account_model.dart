import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
@immutable
class AccountModel{
  final String? documentId;
  final String userId;
  final String name;
  final Decimal balance;

  const AccountModel({
    this.documentId,
    required this.userId,
    required this.name,
    required this.balance,
  });

  toJson(){
    return {
      "userId" : userId,
      "name" : name,
      "balance" : balance.toString(),
    };
  }

  AccountModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot):
    documentId = snapshot.id,
    userId = snapshot.data()["userId"],
    name = snapshot.data()["name"] as String,
    balance = Decimal.fromJson(snapshot.data()["balance"].toString());
}