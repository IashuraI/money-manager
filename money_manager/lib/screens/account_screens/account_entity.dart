import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:money_manager/reposetories/account_repository.dart';
import 'package:money_manager/services/currency_service.dart';
import 'package:money_manager/services/device_preferences_service.dart';
import '../../models/account_model.dart';

class AccountEntity extends StatefulWidget {
  final AccountModel account;
  
  const AccountEntity({
    Key? key,
    required this.account,
  }) : super(key: key);

  @override
  State<AccountEntity> createState() => _AccountEntityState();
}

class _AccountEntityState extends State<AccountEntity> {
  Icon? _icon;
  late final TextEditingController _accountName;
  late String? _currencyName;
  late final TextEditingController _balance;
  late final AccountModelRepository _accountRepository;
  late final List<String?> currencies;
  bool editMode = false;

  @override
  void initState() {
    _icon = Icon(IconData(widget.account.codePoint, fontFamily: widget.account.fontFamily, fontPackage: widget.account.fontPackage));

    _accountName = TextEditingController();
    _balance = TextEditingController();

    _accountName.text = widget.account.name.toString();
    _balance.text = widget.account.balance.toString();

    currencies = CurrencyService.getCurrencyNames();

    _accountRepository = AccountModelRepository();

    _currencyName = widget.account.currency;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.account.name), foregroundColor: const Color.fromRGBO(113, 94, 78, 1), backgroundColor: const Color.fromRGBO(244, 246, 251, 1),),
      body: Padding(
        padding: EdgeInsets.all(getHeight(context) * 0.05),
        child: Column(
          children: [
            Row(
              children: [
                TextButton(onPressed: () async {
                    IconData? icon = await FlutterIconPicker.showIconPicker(context, iconPackModes:  [ IconPack.material ]);
                        
                    setState(() {
                      if(icon!=null){
                        _icon = Icon(icon);
                      }

                      editMode = true;
                    });
                  } , 
                child: _icon!),
                SizedBox(width: getWigth(context) * 0.05,),
                Expanded(child: 
                TextFormField(
                  textAlign: TextAlign.center,
                  controller: _accountName,
                  decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                        labelText: "Account name",
                        hintText: "Account name",
                        border: OutlineInputBorder()
                      ),
                      onChanged: (value) => editMode = true,
                )),
              ],
            ),
            SizedBox(height: getHeight(context)*0.01),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _balance,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'^(([0-9]+\.[0-9]{1,1}[0-9]{1,1})|([0-9]+\.[0-9]{1,1})|([0-9]+\.)|([0-9]+))$'),
                      replacementString: _balance.text)
                    ],
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                      labelText: "Balance",
                      border: OutlineInputBorder()
                    ),
                    onChanged: (value) => editMode = true
                  ),
                ),
                SizedBox(width: getWigth(context) * 0.05,),
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
                      editMode = true;
                    });
                  }
                ),
              ],
            ),
        ]),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              editMode ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if(_icon!=null && _currencyName != null){
                      await _accountRepository.update(documentId: widget.account.documentId!,
                      entity: AccountModel(
                        userId: widget.account.userId, 
                        name: _accountName.text, 
                        balance: Decimal.parse(_balance.text) , 
                        currency: _currencyName!, 
                        codePoint: _icon!.icon!.codePoint,
                        fontFamily: _icon!.icon?.fontFamily,
                        fontPackage: _icon!.icon?.fontPackage,
                        ).toJson());
                    }


                    Navigator.of(context).pop();
                  }, 
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30)))
                  ),
                  child: const Text("Save"),
                ),
              ) : const SizedBox(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                      await _accountRepository.delete(documentId: widget.account.documentId!);
                      
                      Navigator.of(context).pop();
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(228, 235, 242, 1),
                    foregroundColor: const Color.fromRGBO(132, 164, 90, 1),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30)))
                  ),
                  child: const Text("Delete"),
                ),
              ) 
            ],
          )
        ]
      ),
    );
  }
}