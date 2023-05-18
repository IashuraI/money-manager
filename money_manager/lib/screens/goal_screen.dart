import 'package:flutter/material.dart';
import 'package:money_manager/models/goal_model.dart';
import 'package:money_manager/reposetories/goal_repository.dart';
import 'package:money_manager/screens/goal_screens/goal_list.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  late final GoalModelRepository _goalModelRepository;

  @override
  void initState() {
    _goalModelRepository = GoalModelRepository();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Goals"), foregroundColor: const Color.fromRGBO(113, 94, 78, 1), backgroundColor: const Color.fromRGBO(244, 246, 251, 1),),
      body: StreamBuilder<Object>(
        stream: _goalModelRepository.get(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allGoals = snapshot.data as Iterable<GoalModel>;

                return GoalModelListView(
                  goals: allGoals,
                  onTap: (account) {
                    
                  },
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
}