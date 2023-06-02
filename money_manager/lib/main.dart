import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/screens/account_screens/account_screen.dart';
import 'package:money_manager/screens/add_screens/add_account_screen.dart';
import 'package:money_manager/screens/add_screens/add_goal_screen.dart';
import 'package:money_manager/screens/add_screens/add_transaction_screen.dart';
import 'package:money_manager/screens/auth/login_screen.dart';
import 'package:money_manager/screens/auth/signup_screen.dart';
import 'package:money_manager/screens/goal_screens/goal_screen.dart';
import 'package:money_manager/screens/main_screen.dart';
import 'package:money_manager/screens/transaction_screens/transaction_screen.dart';
import 'package:money_manager/screens/setting_screen.dart';
import 'package:money_manager/screens/welcome_screen.dart';
import 'base.dart';

void main() => runApp(
  DevicePreview(
    enabled: true,
    builder: (context) => const MainApp(), // Wrap your app
  ),
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: const Base(),
      routes: {
        '/accounts/':(context) => const AccountScreen(),
        '/goals/':(context) =>  const GoalScreen(),
        '/transactions/':(context) => const TransactionScreen(),
        '/settings/':(context) => const SettingScreen(),
        '/login/':(context) => const LoginScreen(),
        '/signup/':(context) => const SignupScreen(),
        '/home/':(context) => const MainScreen(),
        '/welcome/':(context) => const WelcomeScreen(),
        '/add_account/':(context) => const AddAccountScreen(),
        '/add_goal/':(context) => const AddGoalScreen(),
        '/add_transaction/':(context) => const AddTransactionScreen(),
      },
    );
  }
}

