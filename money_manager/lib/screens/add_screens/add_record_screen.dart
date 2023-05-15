import 'package:decimal/decimal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/models/account_model.dart';
import 'package:money_manager/reposetories/account_repository.dart';
import 'package:money_manager/services/device_preferences_service.dart';

class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({super.key});

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

enum RecordType { income, expenses, transfer }

class _AddRecordScreenState extends State<AddRecordScreen> {
  late final TextEditingController _commentName;
  late final TextEditingController _balance;
  late final TextEditingController _date;
  
  late final AccountModelRepository _accountRepository;

  @override
  void initState() {
    _commentName = TextEditingController();
    _balance = TextEditingController();
    _date = TextEditingController();

    _accountRepository = AccountModelRepository();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Record"), 
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
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                  children: [
                    SizedBox(height: getHeight(context) *0.01),
                    TextFormField(
                      controller: _balance, 
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
                      controller: _commentName,
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
                    ElevatedButton(
                        onPressed: () async {
                          AccountModel newAccount = AccountModel(
                            userId: FirebaseAuth.instance.currentUser!.uid, 
                            name: _commentName.text, 
                            balance: Decimal.parse(_balance.text)
                          );
    
                          _accountRepository.create(newAccount);
    
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
                      controller: _balance, 
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
                      controller: _commentName,
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
                    ElevatedButton(
                        onPressed: () async {
                          AccountModel newAccount = AccountModel(
                            userId: FirebaseAuth.instance.currentUser!.uid, 
                            name: _commentName.text, 
                            balance: Decimal.parse(_balance.text)
                          );
    
                          _accountRepository.create(newAccount);
    
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
                      controller: _balance, 
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
                    ElevatedButton(
                        onPressed: () async {
                          AccountModel newAccount = AccountModel(
                            userId: FirebaseAuth.instance.currentUser!.uid, 
                            name: _commentName.text, 
                            balance: Decimal.parse(_balance.text)
                          );
    
                          _accountRepository.create(newAccount);
    
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
        ),
      ),
    );
  }
}