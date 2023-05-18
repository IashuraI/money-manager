import 'package:flutter/material.dart';
import 'package:money_manager/models/transaction_model.dart';
import 'package:money_manager/screens/transaction_screens/transaction_list.dart';
import '../reposetories/transaction_repository.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {

  late final TransactionModelRepository _transactionModelRepository;

  @override
  void initState() {
    _transactionModelRepository = TransactionModelRepository();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transactions"), foregroundColor: const Color.fromRGBO(113, 94, 78, 1), backgroundColor: const Color.fromRGBO(244, 246, 251, 1),),
      body: StreamBuilder<Object>(
        stream: _transactionModelRepository.get(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allTransactions = snapshot.data as Iterable<TransactionModel>;

                return TransactionModelListView(
                  transactions: allTransactions,
                  onTap: (account) {
                    
                  },
                );
              }
              else {
                return const CircularProgressIndicator();
              }
              default:
                return const CircularProgressIndicator();
            }
        }
      ),
    );
  }

}