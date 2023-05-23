// ignore_for_file: unnecessary_overrides
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
@immutable
class AccountModel{
  final String? documentId;
  final String userId;
  final String name;
  final Decimal balance;
  final String currency;

  final int codePoint;
  final String? fontFamily;
  final String? fontPackage;

  const AccountModel({
    this.documentId,
    required this.userId,
    required this.name,
    required this.balance,
    required this.currency,
    required this.codePoint,
    this.fontFamily,
    this.fontPackage
  });

  toJson(){
    Map<String, String> json = Map.from({
      "userId" : userId,
      "name" : name,
      "balance" : balance.toString(),
      "currency" : currency.toString(),
      "codePoint" : codePoint.toString(),
    });

    if(fontFamily!=null){
      json.putIfAbsent("fontFamily", () => fontFamily!);
    }

    if(fontPackage!=null){
      json.putIfAbsent("fontPackage", () => fontPackage!);
    }

    return json;
  }

  AccountModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot):
    documentId = snapshot.id,
    userId = snapshot.data()["userId"],
    name = snapshot.data()["name"] as String,
    balance = Decimal.fromJson(snapshot.data()["balance"].toString()),
    currency = snapshot.data()["currency"] as String,
    codePoint = int.parse(snapshot.data()["codePoint"].toString()),
    fontFamily = snapshot.data().containsKey("fontFamily") == false ? null :  snapshot.data()["fontFamily"] as String,
    fontPackage = snapshot.data().containsKey("fontPackage") == false ? null : snapshot.data()["fontPackage"] as String;

  @override
  bool operator ==(dynamic other) =>
      other != null && other is AccountModel && other.documentId == documentId;

  @override
  int get hashCode => super.hashCode;
}