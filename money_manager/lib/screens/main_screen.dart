import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:money_manager/screens/account_screen.dart';
import 'package:money_manager/screens/goal_screen.dart';
import 'package:money_manager/screens/transaction_screen.dart';
import 'package:money_manager/screens/setting_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 0;

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const TransactionScreen();

  Color currentColor(int tabIndex){
    return currentTab == tabIndex ? const Color.fromRGBO(228, 235, 242, 0.5) : const Color.fromRGBO(132, 164, 90, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: const Color.fromRGBO(228, 235, 242, 1),
        foregroundColor: const Color.fromRGBO(132, 164, 90, 1),
        spacing: 15,
        spaceBetweenChildren: 20,
        switchLabelPosition: true,
        children: [
          SpeedDialChild(
            onTap: () {
              Navigator.pushNamed(context, "/add_transaction/");
            },
            child: const Icon(Icons.receipt_long, color: Color.fromRGBO(132, 164, 90, 1),), label: "Add Transaction"),
          SpeedDialChild(
            onTap: () {
              Navigator.pushNamed(context, "/add_account/");
            },
            child: const Icon(Icons.account_balance, color: Color.fromRGBO(132, 164, 90, 1),), label: "Add Account"),
          SpeedDialChild(
            onTap: () {
              Navigator.pushNamed(context, "/add_goal/");
            },
            child: const Icon(Icons.add_task, color: Color.fromRGBO(132, 164, 90, 1),), label: "Add Goal")
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Row(
                  children: [ 
                      RawMaterialButton(
                        onPressed: () {
                          setState(() {
                            currentScreen = const TransactionScreen();
                            currentTab = 0;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_long, color: currentColor(0))
                          ],
                        ),
                        ),
                      RawMaterialButton(
                      onPressed: () {
                        setState(() {
                          currentScreen = const AccountScreen();
                          currentTab = 1;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.account_balance, color: currentColor(1))
                        ],
                      ),
                      )
                    ],
                  ),
                Row(
                  children: [ 
                      RawMaterialButton(
                        onPressed: () {
                          setState(() {
                            currentScreen = const GoalScreen();
                            currentTab = 3;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_task, color: currentColor(3))
                          ],
                        ),
                        ),
                      RawMaterialButton(
                      onPressed: () {
                        setState(() {
                          currentScreen = const SettingScreen();
                          currentTab = 4;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.settings, color: currentColor(4))
                        ],
                      ),
                      )
                    ],
                  ),
              ],
          ),
        ),
        ),
    );
  }
}