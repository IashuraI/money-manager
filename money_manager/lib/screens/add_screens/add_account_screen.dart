import 'package:decimal/decimal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/models/account_model.dart';
import 'package:money_manager/reposetories/account_repository.dart';
import '../../services/device_preferences_service.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  late final TextEditingController _accountName;
  late final TextEditingController _balance;
  
  late final AccountModelRepository _accountRepository;

  @override
  void initState() {
    _accountName = TextEditingController();
    _balance = TextEditingController();

    _accountRepository = AccountModelRepository();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = getHeight(context);
    
    return Scaffold(
      appBar: AppBar(title: const Text("Add Account"), foregroundColor: const Color.fromRGBO(113, 94, 78, 1), backgroundColor: const Color.fromRGBO(244, 246, 251, 1),),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            TextFormField(
              controller: _accountName,
              decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    prefixIcon: Icon(Icons.label),
                    labelText: "Account name",
                    hintText: "Account name",
                    border: OutlineInputBorder()
                  ),
            ),
            SizedBox(height: height*0.01),
            TextFormField(
              controller: _balance, 
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    prefixIcon: Icon(Icons.attach_money),
                    labelText: "Balance",
                    hintText: "Balance",
                    border: OutlineInputBorder()
                  ),
            ),
            ElevatedButton(
                  onPressed: () async {
                    AccountModel newAccount = AccountModel(
                      userId: FirebaseAuth.instance.currentUser!.uid, 
                      name: _accountName.text, 
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
    );
  }
}