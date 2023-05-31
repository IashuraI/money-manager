import 'package:money_manager/models/transaction_model.dart';

class FilterTransactionModel{
  DateTime startDate;
  DateTime? endDate;
  Set<TransactionType> list;


  FilterTransactionModel({
    required this.startDate,
    required this.list,
    this.endDate
  });
}