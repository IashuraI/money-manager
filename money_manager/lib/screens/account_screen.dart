import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/services/device_preferences_service.dart';
import '../models/account_model.dart';
import '../reposetories/account_repository.dart';
import 'account_screens/account_list.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late final AccountModelRepository _accountRepository;

  @override
  void initState() {
    _accountRepository = AccountModelRepository();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = getHeight(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Accounts"), foregroundColor: const Color.fromRGBO(113, 94, 78, 1), backgroundColor: const Color.fromRGBO(244, 246, 251, 1),),
      body: StreamBuilder(
        stream: _accountRepository.get(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allAccounts = snapshot.data as Iterable<AccountModel>;
                Decimal total = allAccounts.fold(Decimal.zero, (previousValue, element) => previousValue + element.balance);
                
                return Padding(
                  padding: EdgeInsets.fromLTRB(height * 0.05, height * 0.02, height * 0.05, height * 0.02),
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0,height * 0.02,0,0),
                          child: Text("Total",
                          style: TextStyle(
                            color: const Color.fromRGBO(113, 94, 78, 1),
                            fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
                          )),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0,height * 0.01,0,height * 0.02),
                          child: Text(NumberFormat.simpleCurrency(locale: allAccounts.first.currency, decimalDigits: 2)
                            .format(total.toDouble()),
                          style: TextStyle(
                            color: const Color.fromRGBO(132, 164, 90, 1),
                            fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
                          )),
                        ),
                        Expanded(
                          child: SizedBox(
                            child: AccountModelListView(
                              accounts: allAccounts,
                              onDeleteNote: (account) async {
                                await _accountRepository.delete(documentId: account.documentId! );
                              },
                              onTap: (account) {
                                
                              },
                            ) 
                          )
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
        ),
    );
  }
}