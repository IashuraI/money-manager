import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/models/account_model.dart';

typedef AccountModelCallback = void Function(AccountModel account);

class AccountModelListView extends StatelessWidget {
  final Iterable<AccountModel> accounts;
  final AccountModelCallback onTap;

  const AccountModelListView({
    Key? key,
    required this.accounts,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: GlowingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        color: const Color.fromRGBO(132, 164, 90, 1),
        child: ListView.builder(
          itemCount: accounts.length,
          itemBuilder: (context, index) {
            final account = accounts.elementAt(index);
            return TextButton(
              onPressed: (){
                onTap(account);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0,0,8,0),
                child: ListTile(
                  title: Text(
                    account.name,
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: Icon(IconData(account.codePoint, fontFamily: account.fontFamily, fontPackage: account.fontPackage)),
                  trailing: 
                      Text(
                        NumberFormat.simpleCurrency(name: account.currency, decimalDigits: 2).format(account.balance.toDouble()),
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}