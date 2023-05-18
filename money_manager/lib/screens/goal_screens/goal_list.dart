import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/services/device_preferences_service.dart';

import '../../models/goal_model.dart';

typedef GoalModelCallback = void Function(GoalModel account);

class GoalModelListView extends StatelessWidget {
  final Iterable<GoalModel> goals;
  final GoalModelCallback onTap;

  const GoalModelListView({
    Key? key,
    required this.goals,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = getHeight(context);

    return ListView.builder(
      itemCount: goals.length,
      itemBuilder: (context, index) {
        final goal = goals.elementAt(index);
        return TextButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0,8,8,8),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: const Color.fromRGBO(132, 164, 90, 1),
                    ),
                    child: const Icon(Icons.card_giftcard),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(goal.name, style: Theme.of(context).textTheme.labelLarge,),
                            Text(NumberFormat.simpleCurrency(name: goal.currency, decimalDigits: 2)
                            .format(goal.endAmount.toDouble()), style: Theme.of(context).textTheme.bodyLarge,),
                          ],
                        ),
                        SizedBox(height: height * 0.01,),
                        SizedBox(
                          height: 3,
                          child: LinearProgressIndicator(
                            backgroundColor: const Color.fromRGBO(244, 246, 251, 1),
                            color: const Color.fromRGBO(132, 164, 90, 1),
                            value: goal.balance.toDouble() / (goal.endAmount.toDouble() / 1) ,
                            semanticsLabel: 'Linear progress indicator',
                          ),
                        ),
                        SizedBox(height: height * 0.01,),
                        Text('${NumberFormat.simpleCurrency(name: goal.currency, decimalDigits: 2)
                            .format(goal.balance.toDouble())} accumulated', style: Theme.of(context).textTheme.bodySmall,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        );
      },
    );
  }
}