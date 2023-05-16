import 'package:decimal/decimal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/models/goal_model.dart';
import '../../reposetories/goal_repository.dart';
import '../../services/device_preferences_service.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  late final TextEditingController _name;
  late final TextEditingController _currency;
  late final TextEditingController _goalAmount;
  late final TextEditingController _endDate;
  
  late final GoalModelRepository _goalRepository;

  @override
  void initState() {
    _name = TextEditingController();
    _currency = TextEditingController();
    _goalAmount = TextEditingController();
    _endDate = TextEditingController();

    _goalRepository = GoalModelRepository();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = getHeight(context);
    
    return Scaffold(
      appBar: AppBar(title: const Text("Add Goal"), foregroundColor: const Color.fromRGBO(113, 94, 78, 1), backgroundColor: const Color.fromRGBO(244, 246, 251, 1),),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    prefixIcon: Icon(Icons.label),
                    labelText: "Goal name",
                    hintText: "Goal name",
                    border: OutlineInputBorder()
                  ),
            ),
            SizedBox(height: height*0.01),
            TextFormField(
              controller: _goalAmount,
              decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    prefixIcon: Icon(Icons.attach_money),
                    labelText: "Goal amount",
                    hintText: "Goal amount",
                    border: OutlineInputBorder()
                  ),
            ),
            SizedBox(height: height*0.01),
            TextField(
              controller: _endDate,
              decoration: InputDecoration( 
                icon: const Icon(Icons.calendar_today),
                hintText: DateFormat("EEE, MMM d, yyyy").format(DateTime.now()),
                labelText: "Date",
                border: InputBorder.none
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:DateTime(2000), 
                    lastDate: DateTime(2101)
                );
                if(pickedDate != null ){
                  String formattedDate = DateFormat("EEE, MMM d, yyyy").format(pickedDate);
            
                  setState(() {
                    _endDate.text = formattedDate; 
                  });
                }
              }
            ),
            ElevatedButton(
                  onPressed: () async {
                    GoalModel newGoal = GoalModel(
                      userId: FirebaseAuth.instance.currentUser!.uid, 
                      name: _name.text, 
                      balance: Decimal.zero, 
                      startDate: DateTime.now(), 
                      endAmount: Decimal.fromJson(_goalAmount.text), 
                      currency: "en_US",
                      endDate: _endDate.text.isNotEmpty ? DateFormat("EEE, MMM d, yyyy").parse(_endDate.text) : null,
                    );

                    await _goalRepository.create(newGoal);

                    Navigator.of(context).pop();
                  }, 
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30)))
                  ),
                  child: const Text("Add"),
                )
          ]
          ),
      ),
    );
  }
}