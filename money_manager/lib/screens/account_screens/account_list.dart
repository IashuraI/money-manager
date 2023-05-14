import 'package:flutter/material.dart';
import 'package:money_manager/models/account_model.dart';
import 'package:money_manager/services/device_preferences_service.dart';

typedef AccountModelCallback = void Function(AccountModel account);

class AccountModelListView extends StatelessWidget {
  final Iterable<AccountModel> accounts;
  final AccountModelCallback onDeleteNote;
  final AccountModelCallback onTap;

  const AccountModelListView({
    Key? key,
    required this.accounts,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = getHeight(context);

    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(
        height: height * 0.02,
      ),
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        final account = accounts.elementAt(index);
        return ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Color.fromRGBO(113, 94, 78, 0.3)),
          ),
          onTap: () {
            onTap(account);
          },
          title: Text(
            account.name,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          leading: const Icon(Icons.account_balance),
          trailing: 
              Text(
                account.balance.toString(),
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
        );
      },
    );
  }
}