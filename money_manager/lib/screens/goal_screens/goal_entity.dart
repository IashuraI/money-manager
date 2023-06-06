import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/models/goal_model.dart';
import 'package:money_manager/reposetories/goal_repository.dart';
import 'package:money_manager/screens/goal_screens/top_up_screen.dart';
import 'package:money_manager/services/currency_service.dart';
import 'package:money_manager/services/device_preferences_service.dart';

class GoalEntity extends StatefulWidget {
  final GoalModel goal;
  
  const GoalEntity({
    Key? key,
    required this.goal,
  }) : super(key: key);

  @override
  State<GoalEntity> createState() => _GoalEntityState();
}

class _GoalEntityState extends State<GoalEntity> {
  late final TextEditingController _accountName;
  late final TextEditingController _balance;
  late final GoalModelRepository _goalRepository;
  late final List<String?> currencies;
  bool editMode = false;

  @override
  void initState() {
    _accountName = TextEditingController();
    _balance = TextEditingController();

    _accountName.text = widget.goal.name.toString();
    _balance.text = widget.goal.balance.toString();

    currencies = CurrencyService.getCurrencyNames();

    _goalRepository = GoalModelRepository();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Goal details"), foregroundColor: const Color.fromRGBO(113, 94, 78, 1), backgroundColor: const Color.fromRGBO(244, 246, 251, 1),),
      body: Padding(
        padding: EdgeInsets.all(getHeight(context) * 0.05),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text(widget.goal.name, style: Theme.of(context).textTheme.headlineMedium,)
            ],),
            SizedBox(
              height: getHeight(context) * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text(NumberFormat.simpleCurrency(name: widget.goal.currency, decimalDigits: 2)
                            .format(widget.goal.balance.toDouble()), style: Theme.of(context).textTheme.bodyMedium,),
            ],),
            SizedBox(
              height: getHeight(context) * 0.03,
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 5,
                    child: LinearProgressIndicator(
                    backgroundColor: const Color.fromRGBO(244, 246, 251, 1),
                    color: const Color.fromRGBO(132, 164, 90, 1),
                    value: widget.goal.balance.toDouble() / (widget.goal.endAmount.toDouble() / 1) ,
                    semanticsLabel: 'Linear progress indicator',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: getHeight(context) * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TopUpScreen(goal: widget.goal,)));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(228, 235, 242, 1),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15),
                      ),
                      child: const Icon(Icons.add, color: Color.fromRGBO(132, 164, 90, 1)),
                    ),
                    SizedBox(height: getHeight(context) * 0.01),
                    const Text("Top up"),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(228, 235, 242, 1),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15),
                      ),
                      child: const Icon(Icons.outbond, color: Color.fromRGBO(132, 164, 90, 1)),
                    ),
                    SizedBox(height: getHeight(context) * 0.01),
                    const Text("Withdraw"),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(228, 235, 242, 1),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15),
                      ),
                      child: const Icon(Icons.settings, color: Color.fromRGBO(132, 164, 90, 1)),
                    ),
                    SizedBox(height: getHeight(context) * 0.01),
                    const Text("Settings"),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(228, 235, 242, 1),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15),
                      ),
                      child: const Icon(Icons.close, color: Color.fromRGBO(132, 164, 90, 1)),
                    ),
                    SizedBox(height: getHeight(context) * 0.01),
                    const Text("Close goal"),
                  ],
                ),
              ],
            )
            // Row(
            //   children: [
            //     // TextButton(onPressed: () async {
            //     //     IconData? icon = await FlutterIconPicker.showIconPicker(context, iconPackModes:  [ IconPack.material ]);
                        
            //     //     setState(() {
            //     //       if(icon!=null){
            //     //         _icon = Icon(icon);
            //     //       }

            //     //       editMode = true;
            //     //     });
            //     //   } , 
            //     // child: _icon!),
            //   ],
            // ),
        ]),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                await showDialog(context: context, builder: (context) {
                  Widget noButton = TextButton(
                    child: const Text("No"),
                    onPressed:  () {
                      Navigator.of(context).pop();
                    },
                  );
                  Widget yesButton = TextButton(
                    child: const Text("Yes"),
                    onPressed:  () async {
                      await _goalRepository.delete(documentId: widget.goal.documentId!);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  );

                  AlertDialog alert = AlertDialog(
                    title: const Text("Confirmation"),
                    content: const Text("Are you sure you want to delete this goal and return all transactions to accounts where it came from?"),
                    actions: [
                      yesButton,
                      noButton,
                    ],
                  );

                  return alert;
                });
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(228, 235, 242, 1),
                foregroundColor: const Color.fromRGBO(132, 164, 90, 1),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30)))
              ),
              child: const Text("Delete"),
            ),
          )
        ]
      ),
    );
  }
}