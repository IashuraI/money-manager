import 'package:flutter/material.dart';
import '../../services/device_preferences_service.dart';

class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({super.key});

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  @override
  Widget build(BuildContext context) {
    final height = getHeight(context);
    
    return Scaffold(
      appBar: AppBar(title: const Text("Add Record"), foregroundColor: const Color.fromRGBO(113, 94, 78, 1), backgroundColor: const Color.fromRGBO(244, 246, 251, 1),),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    prefixIcon: Icon(Icons.label),
                    labelText: "Account name",
                    hintText: "Account name",
                    border: OutlineInputBorder()
                  ),
            ),
            SizedBox(height: height*0.01),
            TextFormField(
              decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    prefixIcon: Icon(Icons.attach_money),
                    labelText: "Balance",
                    hintText: "Balance",
                    border: OutlineInputBorder()
                  ),
            ),
            ElevatedButton(
                  onPressed: () async {
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