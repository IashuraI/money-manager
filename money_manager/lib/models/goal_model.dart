import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

@immutable
class GoalModel{
  final String? documentId;
  final String userId;
  final String name;
  final Decimal balance;
  final DateTime startDate;
  final DateTime? endDate;
  final Decimal endAmount;
  final String currency;

  const GoalModel({
    this.documentId,
    required this.userId,
    required this.name,
    required this.balance,
    required this.startDate,
    this.endDate,
    required this.endAmount,
    required this.currency
  });

  toJson(){
    Map<String, dynamic> json = Map<String, dynamic>.from({
      "userId" : userId,
      "name" : name,
      "balance" : balance.toString(),
      "startDate" : DateFormat("EEE, MMM dd, yyyy").format(startDate),
      "endAmount" : endAmount.toString(),
      "currency" : currency.toString()
      });

    if(endDate != null){
      json.putIfAbsent("endDate", () => DateFormat("EEE, MMM dd, yyyy").format(endDate!));
    }
    return json;
  }

  GoalModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot):
    documentId = snapshot.id,
    userId = snapshot.data()["userId"],
    currency = snapshot.data()["currency"] as String,
    name = snapshot.data()["name"] as String,
    balance = Decimal.fromJson(snapshot.data()["balance"].toString()),
    startDate = DateFormat("EEE, MMM dd, yyyy").parse(snapshot.data()["startDate"].toString()),
    endAmount = Decimal.fromJson(snapshot.data()["endAmount"].toString()),
    endDate = snapshot.data().keys.any((element) => element == "endDate") == true ? DateFormat("EEE, MMM d, yyyy").parse(snapshot.data()["endDate"].toString()) : null;
}