import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_manager/models/account_model.dart';
import 'package:money_manager/models/goal_model.dart';
import 'package:money_manager/models/transaction_model.dart';
import 'package:money_manager/reposetories/account_repository.dart';
import 'package:money_manager/reposetories/goal_repository.dart';
import 'package:money_manager/reposetories/transaction_repository.dart';
import 'package:money_manager/services/device_preferences_service.dart';

class TopUpScreen extends StatefulWidget {
  final GoalModel goal;

  const TopUpScreen({
    Key? key,
    required this.goal,
  }) : super(key: key);

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  late final TextEditingController _amount;
  late final AccountModelRepository _accountModelRepository;
  late final GoalModelRepository _goalModelRepository;
  late final TransactionModelRepository _transactionModelRepository;

  AccountModel? _account;

 @override
  void initState() {
    _accountModelRepository = AccountModelRepository();
    _goalModelRepository = GoalModelRepository();
    _transactionModelRepository = TransactionModelRepository();

    _amount = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Top up"), foregroundColor: const Color.fromRGBO(113, 94, 78, 1), backgroundColor: const Color.fromRGBO(244, 246, 251, 1),),
      body: StreamBuilder(
        stream: _accountModelRepository.get(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if(snapshot.hasData){
                final allAccounts = snapshot.data as Iterable<AccountModel>;
                 _account ??= allAccounts.first;
                return Padding(
                  padding: EdgeInsets.fromLTRB(getWigth(context) * 0.1, 0, getWigth(context) * 0.1, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: _account,
                              items: allAccounts.map((account) {
                                  return DropdownMenuItem<AccountModel>(
                                                    value: account,
                                                    child: Text(account.name),
                                  );
                              }).toList(), 
                              onChanged: (AccountModel? value) {
                                setState(() {
                                  _account = value;
                                });
                              }
                            ),
                          ),
                          SizedBox(width: getWigth(context) * 0.05,),
                          Expanded(
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: _amount,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r'^(([0-9]+\.[0-9]{1,1}[0-9]{1,1})|([0-9]+\.[0-9]{1,1})|([0-9]+\.)|([0-9]+))$'),
                                replacementString: _amount.text)
                              ],
                              decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                                labelText: "Amount",
                                border: OutlineInputBorder()
                              ),
                              onChanged: (value) {}
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
              else{
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
            }
        },
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if(_account != null){
                          if(_account!.balance >= Decimal.parse(_amount.text)){
                            await _accountModelRepository.update(documentId: _account!.documentId!, entity: {
                            "balance" : "${_account!.balance - Decimal.parse(_amount.text)}"});

                            await _goalModelRepository.update(documentId: widget.goal.documentId!, entity: {
                              "balance" : "${widget.goal.balance + Decimal.parse(_amount.text)}"});
                            }

                            await _transactionModelRepository.create(TransactionModel(
                              userId: widget.goal.userId, 
                              accountId: _account!.documentId!, 
                              comment: "", 
                              ammount: Decimal.parse(_amount.text), 
                              date: DateTime.now(),
                              type: TransactionType.goalIncome, 
                              currency: widget.goal.currency));
                        }
                          Navigator.of(context).pop();
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(228, 235, 242, 1),
                        foregroundColor: const Color.fromRGBO(132, 164, 90, 1),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30)))
                      ),
                      child: const Text("Top up"),
                    ),
                  ),
        ],
      ) ,
    );
  }
}