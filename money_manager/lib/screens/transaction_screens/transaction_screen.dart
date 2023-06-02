import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/models/filter_transaction_model.dart';
import 'package:money_manager/models/transaction_model.dart';
import 'package:money_manager/screens/transaction_screens/transaction_entity.dart';
import 'package:money_manager/screens/transaction_screens/transaction_list.dart';
import '../../reposetories/transaction_repository.dart';
import 'package:jiffy/jiffy.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  bool expenses = true, income = true, goalIncome = true, goalWithdrawal = true, transfer = true;
  late final List<bool> periods;

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

    periods = [true, false, false, false, false];

    super.initState();
  }

  switchPeriod(int elementId){
    periods[elementId] = !periods[elementId];

    for (int i = 0; i < periods.length; i++) 
    { 
      if(i != elementId){
        periods[i] = false; 
      }
    }
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
                                    return StatefulBuilder(builder: (context, setState) {
                                      return SizedBox(
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () => {
                                                    setState(() {
                                                      Navigator.pop(context);
                                                    },)
                                                  },
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
                                                      TextButton(
                                                        style: TextButton.styleFrom(
                                                          backgroundColor: periods[0] == true ?const Color.fromARGB(255, 229, 229, 229) : Colors.transparent
                                                        ),
                                                        onPressed: () {
                                                        setState(() {
                                                        switchPeriod(0);
                                                        _notSaved.startDate = _now.dateTime;
                                                        _notSaved.endDate = null;
                                                        });
                                                      }, child: const Text("Day", style: TextStyle(color: Color.fromRGBO(132, 164, 90, 1)),)),
                                                      TextButton(
                                                        style: TextButton.styleFrom(
                                                          backgroundColor: periods[1] == true ?const Color.fromARGB(255, 229, 229, 229) : Colors.transparent
                                                        ),
                                                        onPressed: () {
                                                        setState(() {
                                                        switchPeriod(1);
                                                        _notSaved.startDate = _now.subtract(days: 7).dateTime;
                                                        _notSaved.endDate = _now.dateTime;
                                                        });
                                                      }, child: const Text("Week", style: TextStyle(color: Color.fromRGBO(132, 164, 90, 1)),)),
                                                      TextButton(
                                                        style: TextButton.styleFrom(
                                                          backgroundColor: periods[2] == true ?const Color.fromARGB(255, 229, 229, 229) : Colors.transparent
                                                        ),
                                                        onPressed: () {
                                                        setState(() {
                                                          switchPeriod(2);
                                                          _notSaved.startDate = Jiffy.now().subtract(months: 1).dateTime;
                                                          _notSaved.endDate = _now.dateTime;
                                                        });
                                                      }, child: const Text("Month", style: TextStyle(color: Color.fromRGBO(132, 164, 90, 1)),)),
                                                      TextButton(
                                                        style: TextButton.styleFrom(
                                                          backgroundColor: periods[3] == true ?const Color.fromARGB(255, 229, 229, 229) : Colors.transparent
                                                        ),
                                                        onPressed: () {
                                                        setState(() {
                                                          switchPeriod(3);
                                                          _notSaved.startDate = Jiffy.now().subtract(years: 1).dateTime;
                                                          _notSaved.endDate = _now.dateTime;
                                                        });
                                                      }, child: const Text("Year", style: TextStyle(color: Color.fromRGBO(132, 164, 90, 1)),)),
                                                      TextButton(
                                                        style: TextButton.styleFrom(
                                                          backgroundColor: periods[4] == true ?const Color.fromARGB(255, 229, 229, 229) : Colors.transparent
                                                        ),
                                                        onPressed: () {
                                                        setState(() {
                                                          switchPeriod(4);
                                                          _notSaved.startDate = Jiffy.now().subtract(years: 1).dateTime;
                                                          _notSaved.endDate = _now.dateTime;
                                                        });
                                                      }, child: const Text("Period", style: TextStyle(color: Color.fromRGBO(132, 164, 90, 1)),)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text("By type", style: Theme.of(context).textTheme.bodyLarge,),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(8,0,8,0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        child: CheckboxListTile(
                                                          fillColor: const MaterialStatePropertyAll(Color.fromRGBO(132, 164, 90, 1)),
                                                          value: expenses,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                              expenses = value!;
                                                            });
                                                          },
                                                          title: const Text('Expanses', style: TextStyle(color: Color.fromRGBO(132, 164, 90, 1)),),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: CheckboxListTile(
                                                          fillColor: const MaterialStatePropertyAll(Color.fromRGBO(132, 164, 90, 1)),
                                                          value: income,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                              income = value!;
                                                            });
                                                          },
                                                          title: const Text('Income', style: TextStyle(color: Color.fromRGBO(132, 164, 90, 1)),),
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
                                                      fillColor: const MaterialStatePropertyAll(Color.fromRGBO(132, 164, 90, 1)),
                                                      value: goalIncome,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          goalIncome = value!;
                                                        });
                                                      },
                                                      title: const Text('Goal income', style: TextStyle(color: Color.fromRGBO(132, 164, 90, 1)),),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: CheckboxListTile(
                                                      fillColor: const MaterialStatePropertyAll(Color.fromRGBO(132, 164, 90, 1)),
                                                      value: goalWithdrawal,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          goalWithdrawal = value!;
                                                        });
                                                      },
                                                      title: const Text('Goal withdrawal', style: TextStyle(color: Color.fromRGBO(132, 164, 90, 1)),),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(8,0,8,0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                Expanded(
                                                    child: CheckboxListTile(
                                                      fillColor: const MaterialStatePropertyAll(Color.fromRGBO(132, 164, 90, 1)),
                                                      value: transfer,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          transfer = value!;
                                                        });
                                                      },
                                                      title: const Text('Transfers', style: TextStyle(color: Color.fromRGBO(132, 164, 90, 1)),),
                                                    ),
                                                  ),
                                              ]),
                                            ),
                                            TextButton(onPressed: (){
                                              setState(() {
                                                if(periods.any((element) => element == true)){
                                                _current.endDate = _notSaved.endDate;
                                                _current.startDate = _notSaved.startDate;
                                                }
                                                else{
                                                  _current.startDate = DateTime.now();
                                                }

                                                
                                                Set<TransactionType> types = {};
                                                if(income){
                                                  types.add(TransactionType.income);
                                                }
                                                if(expenses){
                                                  types.add(TransactionType.expense);
                                                }
                                                if(goalIncome){
                                                  types.add(TransactionType.goalIncome);
                                                }
                                                if(goalWithdrawal){
                                                  types.add(TransactionType.goalWithdrawal);
                                                }
                                                if(transfer){
                                                  types.add(TransactionType.transfer);
                                                }

                                                _notSaved.list = types;

                                                _current.list = _notSaved.list;
                                                
                                                Navigator.of(context).pop();
                                              });
                                            }, child: const Text("Apply Filters", style: TextStyle(color: Color.fromRGBO(132, 164, 90, 1)),))
                                          ],
                                        ),
                                      ),
                                    );
                                    });
                                  },
                                );

                                setState(() {
                                  
                                });
                              }, 
                              icon: const Icon(Icons.filter_alt_outlined), 
                              label: const Text("Filter", style: TextStyle(color: Color.fromRGBO(132, 164, 90, 1)),),
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
