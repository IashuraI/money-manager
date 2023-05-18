import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/models/transaction_model.dart';
import 'package:money_manager/screens/transaction_screens/transaction_list.dart';
import '../reposetories/transaction_repository.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  int touchedIndex = -1;
  late final TransactionModelRepository _transactionModelRepository;

  @override
  void initState() {
    _transactionModelRepository = TransactionModelRepository();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transactions"), foregroundColor: const Color.fromRGBO(113, 94, 78, 1), backgroundColor: const Color.fromRGBO(244, 246, 251, 1),),
      body: StreamBuilder<Object>(
        stream: _transactionModelRepository.get(),
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
                    Expanded(
                            child: TransactionModelListView(
                              transactions: allTransactions,
                              onTap: (account) {
                                
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
