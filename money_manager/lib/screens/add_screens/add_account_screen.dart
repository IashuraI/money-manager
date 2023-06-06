import 'package:decimal/decimal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker_plus/flutter_iconpicker.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/models/account_model.dart';
import 'package:money_manager/reposetories/account_repository.dart';
import 'package:money_manager/services/currency_service.dart';
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

  late final List<String?> currencies;
  String? _currencyName;

  Icon? _icon;

  @override
  void initState() {
    _icon = const Icon(Icons.add);

    _accountName = TextEditingController();
    _balance = TextEditingController();

    _accountRepository = AccountModelRepository();

    currencies = CurrencyService.getCurrencyNames();

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
            Row(
              children: [
                Text("Currency", style: Theme.of(context).textTheme.titleMedium,),
                SizedBox(width: getWigth(context)*0.2),
                DropdownButton(
                  value: _currencyName,
                  items: currencies.map((locale) {
                      return DropdownMenuItem<String>(
                                        value: locale,
                                        child: Text(locale!),
                      );
                  }).toList(), 
                  onChanged: (String? value) {
                    setState(() {
                      _currencyName = value;
                    });
                  }
                ),
                SizedBox(width: getWigth(context)*0.05),
                Text(NumberFormat.simpleCurrency(name: _currencyName).currencySymbol),
              ],
            ),
            Row(
              children: [
                Text("Icon:", style: Theme.of(context).textTheme.titleMedium),
                TextButton(onPressed: () async {
                  IconData? icon = await FlutterIconPicker.showIconPicker(context, iconPackModes:  [ IconPack.material ]);

                  setState(() {
                    _icon = Icon(icon);
                  });
                } , child: _icon!),
              ],
            ),
            ElevatedButton(
                  onPressed: () async {
                    if (_currencyName != null && _icon != null) {
                      AccountModel newAccount = AccountModel(
                        userId: FirebaseAuth.instance.currentUser!.uid, 
                        name: _accountName.text, 
                        balance: Decimal.parse(_balance.text),
                        currency: _currencyName!,
                        codePoint: _icon!.icon!.codePoint,
                        fontFamily: _icon!.icon?.fontFamily,
                        fontPackage: _icon!.icon?.fontPackage
                      );
                      
                      await _accountRepository.create(newAccount);
                      
                      Navigator.of(context).pop();
                    }
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