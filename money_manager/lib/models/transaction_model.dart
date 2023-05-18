import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

enum TransactionType { expense, income, transfer, goalTransfer }

@immutable
class TransactionModel{
  final String? documentId;
  final String userId;
  final String accountId;
  final String? accountIdReciver;
  final String comment;
  final Decimal ammount;
  final DateTime date;
  final TransactionType type;
  final String currency;


  const TransactionModel({
    this.documentId,
    required this.userId,
    required this.accountId,
    required this.comment,
    required this.ammount,
    required this.date,
    required this.type,
    required this.currency,
    this.accountIdReciver
  });

  toJson(){
    Map<String, dynamic> json = Map<String, dynamic>.from(
      {
      "userId" : userId,
      "accountId" : accountId,
      "comment" : comment,
      "ammount" : ammount.toString(),
      "date" : DateFormat("EEE, MMM dd, yyyy").format(date),
      "type" : type.toString(),
      "currency" : currency.toString()
    });

    if(accountIdReciver != null){
      json.putIfAbsent("accountIdReciver", () => accountIdReciver);
    }
    return json;
  }

  TransactionModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot):
    documentId = snapshot.id,
    userId = snapshot.data()["userId"],
    accountId = snapshot.data()["accountId"].toString(),
    comment = snapshot.data()["comment"].toString(),
    currency = snapshot.data()["currency"].toString(),
    ammount = Decimal.fromJson(snapshot.data()["ammount"].toString()),
    date = DateFormat("EEE, MMM d, yyyy").parse(snapshot.data()["date"].toString()),
    type = TransactionType.values.firstWhere((e) => e.toString() == snapshot.data()["type"].toString()),
    accountIdReciver = snapshot.data().keys.any((element) => element == "accountIdReciver") == true ? snapshot.data()["accountIdReciver"].toString().toString() : null;
}