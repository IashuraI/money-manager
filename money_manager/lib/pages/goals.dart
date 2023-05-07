import 'package:flutter/material.dart';

class Goal extends StatefulWidget {
  const Goal({super.key});

  @override
  State<Goal> createState() => _GoalState();
}

class _GoalState extends State<Goal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Goals"), foregroundColor: const Color.fromRGBO(113, 94, 78, 1), backgroundColor: const Color.fromRGBO(244, 246, 251, 1),),
      body: const Center(child: Text("Goals")),
    );
  }
}