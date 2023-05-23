import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/services/device_preferences_service.dart';
import '../../models/transaction_model.dart';

typedef TransactionModelCallback = void Function(TransactionModel transaction);

class TransactionModelListView extends StatelessWidget {
  final Iterable<TransactionModel> transactions;
  final TransactionModelCallback onTap;

  const TransactionModelListView({
    Key? key,
    required this.transactions,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = getHeight(context);

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions.elementAt(index);
        return TextButton(
            onPressed: () {
              onTap(transaction);
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0,8,8,8),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      onTap(transaction);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: const Color.fromRGBO(132, 164, 90, 1),
                    ),
                    child: const Icon(Icons.card_giftcard),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(DateFormat("EEE, MMM dd, yyyy").format(transaction.date), style: Theme.of(context).textTheme.labelLarge,),
                            Text(NumberFormat.simpleCurrency(name: transaction.currency, decimalDigits: 2)
                            .format(transaction.ammount.toDouble()), style: Theme.of(context).textTheme.bodyLarge,),
                          ],
                        ),
                        SizedBox(height: height * 0.01,),
                        Text('${transaction.comment} accumulated', style: Theme.of(context).textTheme.bodySmall,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        );
      },
    );
  }
}