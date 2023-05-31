import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/models/filter_transaction_model.dart';
import 'package:money_manager/models/transaction_model.dart';
import 'package:money_manager/screens/transaction_screens/transaction_entity.dart';
import 'package:money_manager/screens/transaction_screens/transaction_list.dart';
import 'package:money_manager/services/device_preferences_service.dart';
import '../../reposetories/transaction_repository.dart';
import 'package:jiffy/jiffy.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  int touchedIndex = -1;
  late final TransactionModelRepository _transactionModelRepository;

  late FilterTransactionModel _current;
  late FilterTransactionModel _notSaved;

  late final Jiffy _now; 

  @override
  void initState() {
    _transactionModelRepository = TransactionModelRepository();

    _now = Jiffy.now();

    _current = FilterTransactionModel(
      startDate: _now.dateTime, 
      list: {
        TransactionType.expense,
        TransactionType.transfer,
        TransactionType.goalIncome,
        TransactionType.goalWithdrawal,
        TransactionType.income
      });

    _notSaved = FilterTransactionModel(
      startDate: _now.dateTime, 
      list: {
        TransactionType.expense,
        TransactionType.transfer,
        TransactionType.goalIncome,
        TransactionType.goalWithdrawal,
        TransactionType.income
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Transactions"), 
          foregroundColor: const Color.fromRGBO(113, 94, 78, 1), 
          backgroundColor: const Color.fromRGBO(244, 246, 251, 1),
          ),
        body: StreamBuilder(
          stream: _transactionModelRepository.getbyFilter(_current),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allTransactions = snapshot.data as Iterable<TransactionModel>;
 
                  return Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1.3,
                          child: Column(
                            children: [
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: PieChart(
                                    PieChartData(
                                      pieTouchData: PieTouchData(
                                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                          setState(() {
                                            if (!event.isInterestedForInteractions ||
                                                pieTouchResponse == null ||
                                                pieTouchResponse.touchedSection == null) {
                                              touchedIndex = -1;
                                              return;
                                            }
                                            touchedIndex = pieTouchResponse
                                                .touchedSection!.touchedSectionIndex;
                                          });
                                        },
                                      ),
                                      centerSpaceRadius: 40,
                                      sections: showingSections(allTransactions),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(child: Center(child: Text("${DateFormat("EEE, MMM dd, yyyy").format(_current.startDate)}${_current.endDate == null ? " " : " - ${DateFormat("EEE, MMM dd, yyyy").format(_current.endDate!)}"}"))),
                            ElevatedButton.icon(
                              onPressed: () async{
                                await showModalBottomSheet<void>(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30),
                                    ),
                                  ),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      height: getHeight(context) * 0.4,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  style: ElevatedButton.styleFrom(
                                                  shape: const CircleBorder(),
                                                  elevation: 0,
                                                  backgroundColor: Colors.transparent,
                                                  foregroundColor: const Color.fromRGBO(132, 164, 90, 1)
                                                  ),
                                                  child: const Icon(Icons.close),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Center(child: Text("By date", style: Theme.of(context).textTheme.bodyLarge,)),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      TextButton(onPressed: () {
                                                        setState(() {
                                                        _notSaved.startDate = _now.dateTime;
                                                        _notSaved.endDate = null;
                                                        });
                                                      }, child: const Text("Day")),
                                                      TextButton(onPressed: () {
                                                        setState(() {
                                                        _notSaved.startDate = _now.subtract(days: 7).dateTime;
                                                        _notSaved.endDate = _now.dateTime;
                                                        });
                                                      }, child: const Text("Week")),
                                                      TextButton(onPressed: () {
                                                        setState(() {
                                                          _notSaved.startDate = Jiffy.now().subtract(months: 1).dateTime;
                                                          _notSaved.endDate = _now.dateTime;
                                                        });
                                                      }, child: const Text("Month")),
                                                      TextButton(onPressed: () {
                                                        setState(() {
                                                          _notSaved.startDate = Jiffy.now().subtract(years: 1).dateTime;
                                                          _notSaved.endDate = _now.dateTime;
                                                        });
                                                      }, child: const Text("Year")),
                                                      TextButton(onPressed: () {
                                                        setState(() {
                                                          _notSaved.startDate = Jiffy.now().subtract(years: 1).dateTime;
                                                          _notSaved.endDate = _now.dateTime;
                                                        });
                                                      }, child: const Text("Period")),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text("By type", style: Theme.of(context).textTheme.bodyLarge ,),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(8,0,8,0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        child: CheckboxListTile(
                                                          value: true,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                            });
                                                          },
                                                          title: const Text('Expanses'),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: CheckboxListTile(
                                                          value: true,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                            });
                                                          },
                                                          title: const Text('Income'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(8,0,8,8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: CheckboxListTile(
                                                      value: true,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                        });
                                                      },
                                                      title: const Text('Goal income'),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: CheckboxListTile(
                                                      value: true,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                        });
                                                      },
                                                      title: const Text('Goal withdrawal'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            TextButton(onPressed: (){
                                              setState(() {
                                                _current.endDate = _notSaved.endDate;
                                                _current.startDate = _notSaved.startDate;
                                                _current.list = _notSaved.list;
                                                Navigator.of(context).pop();
                                              });
                                            }, child: const Text("Apply Filters"))
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                                if(true){
                                 //apply filters 
                                }
                              }, 
                              icon: const Icon(Icons.filter_alt_outlined), 
                              label: const Text("Filter"),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                foregroundColor: const Color.fromRGBO(132, 164, 90, 1)
                              ),),
                          ],
                        ),
                        Expanded(
                          child: TransactionModelListView(
                            transactions: allTransactions,
                            onTap: (transaction) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionEntity(transaction: transaction)));
                            },
                          ),
                        ),
                      ],
                    );
                }
                else {
                  return const CircularProgressIndicator();
                }
                default:
                  return const CircularProgressIndicator();
              }
          }
        ),
      );
  }

  List<PieChartSectionData> showingSections(Iterable<TransactionModel> transactions) {
    List<PieChartSectionData> pcsd = List.empty(growable: true);
    for(int i = 0; i < transactions.length; i++){
      pcsd.add(
          PieChartSectionData(
            color: Colors.red,
            value: transactions.elementAt(i).ammount.toDouble(),
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
              shadows: [Shadow(color: Colors.black, blurRadius: 2)],
            ),
          )
      );
    }

    return pcsd;
  }
}
