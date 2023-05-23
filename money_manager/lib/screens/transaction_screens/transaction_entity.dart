import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/models/account_model.dart';
import 'package:money_manager/models/transaction_model.dart';
import 'package:money_manager/reposetories/account_repository.dart';
import 'package:money_manager/reposetories/transaction_repository.dart';
import 'package:money_manager/services/currency_service.dart';
import 'package:money_manager/services/device_preferences_service.dart';

class TransactionEntity extends StatefulWidget {
  final TransactionModel transaction;
  
  const TransactionEntity({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  State<TransactionEntity> createState() => _TransactionEntityState();
}

class _TransactionEntityState extends State<TransactionEntity> {
  late final TextEditingController _comment;
  late String? _currencyName;
  late final TextEditingController _amount;
  late final TextEditingController _date;
  late final TransactionModelRepository _transactionRepository;
  late final AccountModelRepository _accountModelRepository;
  AccountModel? _account;
  late final List<String?> currencies;
  bool editMode = false;

  @override
  void initState() {
    _comment = TextEditingController();
    _amount = TextEditingController();
    _date = TextEditingController();

    _comment.text = widget.transaction.comment.toString();
    _amount.text = widget.transaction.ammount.toString();
    _date.text = DateFormat("EEE, MMM d, yyyy").format(widget.transaction.date);

    currencies = CurrencyService.getCurrencyNames();

    _transactionRepository = TransactionModelRepository();
    _accountModelRepository = AccountModelRepository();

    _currencyName = widget.transaction.currency;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transaction details"), foregroundColor: const Color.fromRGBO(113, 94, 78, 1), backgroundColor: const Color.fromRGBO(244, 246, 251, 1),),
      body: StreamBuilder<Object>(
        stream: _accountModelRepository.get(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if(snapshot.hasData){
                final allAccounts = snapshot.data as Iterable<AccountModel>;

                _account = allAccounts.where((element) => element.documentId == widget.transaction.accountId).first;

                return Padding(
                  padding: EdgeInsets.all(getHeight(context) * 0.05),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _amount,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r'^(([0-9]+\.[0-9]{1,1}[0-9]{1,1})|([0-9]+\.[0-9]{1,1})|([0-9]+\.)|([0-9]+))$'),
                                replacementString: _amount.text)
                              ],
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                                labelText: "Amount",
                                border: OutlineInputBorder()
                              ),
                              onChanged: (value) => setState(() {
                                editMode = true;
                              })
                            ),
                          ),
                          SizedBox(width: getWigth(context) * 0.1,),
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
                      SizedBox(height: getHeight(context) * 0.02,),
                      Row(
                        children: [
                          const Text("Account:"),
                          SizedBox(width: getWigth(context) * 0.1,),
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
                          SizedBox(height: getHeight(context)*0.01),
                        ]),
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
                                  editMode = true;
                                });
                              }
                            }
                          )
                  ]),
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
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              editMode ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if(_currencyName != null){
                      await _transactionRepository.update(documentId: widget.transaction.documentId!,
                      entity: {});
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
                      await _transactionRepository.delete(documentId: widget.transaction.documentId!);
                      
                      Navigator.of(context).pop();
                  }, 
                  style: ElevatedButton.styleFrom(
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