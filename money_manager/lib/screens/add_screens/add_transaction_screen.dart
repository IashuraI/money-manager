import 'package:decimal/decimal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/models/account_model.dart';
import 'package:money_manager/models/transaction_model.dart';
import 'package:money_manager/reposetories/account_repository.dart';
import 'package:money_manager/reposetories/transaction_repository.dart';
import 'package:money_manager/services/device_preferences_service.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  late final TextEditingController _comment;
  late final TextEditingController _amount;
  late final TextEditingController _date;
  
  late final TransactionModelRepository _transactionRepository;
  late final AccountModelRepository _accountModelRepository;
  AccountModel? _account;
  AccountModel? _toAccount;

  @override
  void initState() {
    _comment = TextEditingController();
    _amount = TextEditingController();
    _date = TextEditingController();

    _transactionRepository = TransactionModelRepository();
    _accountModelRepository = AccountModelRepository();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Transaction"), 
          foregroundColor: const Color.fromRGBO(113, 94, 78, 1), 
          backgroundColor: const Color.fromRGBO(244, 246, 251, 1),
          bottom: const TabBar(
            labelColor: Color.fromRGBO(113, 94, 78, 1),
            tabs: [
              Tab(text: "EXPENSES"),
              Tab(text: "INCOME"),
              Tab(text: "TRANSFER"),
            ],
          ),
        ),
        body: StreamBuilder(
          stream: _accountModelRepository.get(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
            if(snapshot.hasData){
              final allAccounts = snapshot.data as Iterable<AccountModel>;
              return TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                        children: [
                          SizedBox(height: getHeight(context) *0.01),
                          TextFormField(
                            controller: _amount, 
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                                  prefixIcon: Icon(Icons.attach_money),
                                  labelText: "Amount",
                                  hintText: "0",
                                  border: OutlineInputBorder()
                                ),
                          ),
                          SizedBox(height: getHeight(context) *0.01),
                          TextFormField(
                            controller: _comment,
                            decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                                  prefixIcon: Icon(Icons.label),
                                  labelText: "Comment",
                                  hintText: "Comment",
                                  border: OutlineInputBorder()
                                ),
                          ),
                          SizedBox(height: getHeight(context) *0.01),
                          TextField(
                            controller: _date,
                            decoration: InputDecoration( 
                              icon: const Icon(Icons.calendar_today),
                              hintText: DateFormat("EEE, MMM d, yyyy").format(DateTime.now()),
                              labelText: "Date",
                              border: InputBorder.none
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate:DateTime(2000), 
                                  lastDate: DateTime(2101)
                              );
                              if(pickedDate != null ){
                                String formattedDate = DateFormat("EEE, MMM d, yyyy").format(pickedDate);
                          
                                setState(() {
                                  _date.text = formattedDate; 
                                });
                              }
                            }
                          ),
                          Row(
                            children: [
                              Text("Account", style: Theme.of(context).textTheme.titleMedium,),
                              SizedBox(width: getWigth(context)*0.2),
                              DropdownButton(
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
                            ],
                          ),
                          SizedBox(height: getHeight(context) *0.01),
                          ElevatedButton(
                              onPressed: () async {
                                TransactionModel newTransaction = TransactionModel(
                                  userId: FirebaseAuth.instance.currentUser!.uid,
                                  accountId: _account!.documentId!,
                                  comment: _comment.text,
                                  ammount: Decimal.parse(_amount.text),
                                  date: DateFormat("EEE, MMM d, yyyy").parse(_date.text),
                                  type: TransactionType.expense,
                                  currency: _account!.currency
                                );
              
                                await _transactionRepository.create(newTransaction);

                                await _accountModelRepository.update(documentId: _account!.documentId!, entity: { "balance" : (_account!.balance -  Decimal.parse(_amount.text)).toString()});
                                Navigator.of(context).pop();
                              }, 
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30)))
                              ),
                              child: const Text("Add"),
                            )
                      ]
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                        children: [
                          SizedBox(height: getHeight(context) *0.01),
                          TextFormField(
                            controller: _amount, 
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                                  prefixIcon: Icon(Icons.attach_money),
                                  labelText: "Amount",
                                  hintText: "0",
                                  border: OutlineInputBorder()
                                ),
                          ),
                          SizedBox(height: getHeight(context) *0.01),
                          TextFormField(
                            controller: _comment,
                            decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                                  prefixIcon: Icon(Icons.label),
                                  labelText: "Comment",
                                  hintText: "Comment",
                                  border: OutlineInputBorder()
                                ),
                          ),
                          SizedBox(height: getHeight(context) *0.01),
                          TextField(
                            controller: _date,
                            decoration: InputDecoration( 
                              icon: const Icon(Icons.calendar_today),
                              hintText: DateFormat("EEE, MMM d, yyyy").format(DateTime.now()),
                              labelText: "Date",
                              border: InputBorder.none
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate:DateTime(2000), 
                                  lastDate: DateTime(2101)
                              );
                              if(pickedDate != null ){
                                String formattedDate = DateFormat("EEE, MMM d, yyyy").format(pickedDate);
                          
                                setState(() {
                                  _date.text = formattedDate; 
                                });
                              }
                            }
                          ),
                          Row(
                            children: [
                              Text("Account", style: Theme.of(context).textTheme.titleMedium,),
                              SizedBox(width: getWigth(context)*0.2),
                              DropdownButton(
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
                            ],
                          ),
                          SizedBox(height: getHeight(context) *0.01),
                          ElevatedButton(
                              onPressed: () async {
                                TransactionModel newTransaction = TransactionModel(
                                  userId: FirebaseAuth.instance.currentUser!.uid,
                                  accountId: _account!.documentId!,
                                  comment: _comment.text,
                                  ammount: Decimal.parse(_amount.text),
                                  date: DateFormat("EEE, MMM d, yyyy").parse(_date.text),
                                  type: TransactionType.income,
                                  currency: _account!.currency
                                );
              
                                await _transactionRepository.create(newTransaction);

                                await _accountModelRepository.update(documentId: _account!.documentId!, entity: { "balance" : (_account!.balance +  Decimal.parse(_amount.text)).toString()});
              
                                Navigator.of(context).pop();
                              }, 
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30)))
                              ),
                              child: const Text("Add"),
                            )
                      ]
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                        children: [
                          SizedBox(height: getHeight(context) *0.01),
                          TextFormField(
                            controller: _amount, 
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                                  prefixIcon: Icon(Icons.attach_money),
                                  labelText: "Amount",
                                  hintText: "0",
                                  border: OutlineInputBorder()
                                ),
                          ),
                          SizedBox(height: getHeight(context) *0.01),
                          TextFormField(
                            controller: _comment,
                            decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                                  prefixIcon: Icon(Icons.label),
                                  labelText: "Comment",
                                  hintText: "Comment",
                                  border: OutlineInputBorder()
                                ),
                          ),
                          SizedBox(height: getHeight(context) *0.01),
                          TextField(
                            controller: _date,
                            decoration: InputDecoration( 
                              icon: const Icon(Icons.calendar_today),
                              hintText: DateFormat("EEE, MMM d, yyyy").format(DateTime.now()),
                              labelText: "Date",
                              border: InputBorder.none
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate:DateTime(2000), 
                                  lastDate: DateTime(2101)
                              );
                              if(pickedDate != null ){
                                String formattedDate = DateFormat("EEE, MMM d, yyyy").format(pickedDate);
                          
                                setState(() {
                                  _date.text = formattedDate; 
                                });
                              }
                            }
                          ),
                          SizedBox(height: getHeight(context) *0.01),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text("From Account", style: Theme.of(context).textTheme.titleMedium,),
                                  SizedBox(width: getWigth(context)*0.2),
                                  DropdownButton(
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
                                ],
                              ),
                              Row(
                                children: [
                                  Text("To Account", style: Theme.of(context).textTheme.titleMedium,),
                                  SizedBox(width: getWigth(context)*0.2),
                                  DropdownButton(
                                    value: _toAccount,
                                    items: allAccounts.map((account) {
                                        return DropdownMenuItem<AccountModel>(
                                                          value: account,
                                                          child: Text(account.name),
                                        );
                                    }).toList(), 
                                    onChanged: (AccountModel? value) {
                                      setState(() {
                                        _toAccount = value;
                                      });
                                    }
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: getHeight(context) *0.01),
                          ElevatedButton(
                              onPressed: () async {
                                TransactionModel newTransaction = TransactionModel(
                                  userId: FirebaseAuth.instance.currentUser!.uid,
                                  accountId: _account!.documentId!,
                                  comment: _comment.text,
                                  ammount: Decimal.parse(_amount.text),
                                  date: DateFormat("EEE, MMM d, yyyy").parse(_date.text),
                                  type: TransactionType.transfer,
                                  accountIdReciver: _toAccount!.documentId!,
                                  currency: _toAccount!.currency
                                );
              
                                await _transactionRepository.create(newTransaction);

                                await _accountModelRepository.update(documentId: _account!.documentId!, entity: { "balance" : (_account!.balance -  Decimal.parse(_amount.text)).toString()});
                                await _accountModelRepository.update(documentId: _toAccount!.documentId!, entity: { "balance" : (_toAccount!.balance +  Decimal.parse(_amount.text)).toString()});
              
                                Navigator.of(context).pop();
                              }, 
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30)))
                              ),
                              child: const Text("Transfer"),
                            )
                        ]
                    )
                  ),
                ],
              );
            }
            else{
              return const CircularProgressIndicator();
            }
            default:
              return const CircularProgressIndicator();
            }
          }
        ),
      ),
    );
  }
}