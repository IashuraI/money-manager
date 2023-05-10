import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings"), foregroundColor: const Color.fromRGBO(113, 94, 78, 1), backgroundColor: const Color.fromRGBO(244, 246, 251, 1),),
      body: ListView(
        padding: const EdgeInsets.all(20),
        shrinkWrap: true,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Account", style: Theme.of(context).textTheme.headlineSmall),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                backgroundColor: const Color.fromRGBO(132, 164, 90, 1),
                              ),
                              child: const Icon(Icons.person),
                            ),
                            TextButton(
                              onPressed: () {}, 
                              style: TextButton.styleFrom(),
                              child: Text(FirebaseAuth.instance.currentUser!.email!),
                              ),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.of(context).popAndPushNamed("/welcome/");
                          },    
                          child: Text("Logout", style: Theme.of(context).textTheme.bodyMedium)
                    ),
                  ],
                ),
                
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Management", style: Theme.of(context).textTheme.headlineSmall),
              ),
              TextButton(
                onPressed: () {},
                style: const ButtonStyle(
                    alignment: Alignment.centerLeft,
                  ),
                child: Text("Categories", style: Theme.of(context).textTheme.bodyMedium),
                ),
              TextButton(
                onPressed: () {},
                style: const ButtonStyle(
                    alignment: Alignment.centerLeft,
                  ),
                child: Text("Regular payments", style: Theme.of(context).textTheme.bodyMedium),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Configuration", style: Theme.of(context).textTheme.headlineSmall),
              ),
              TextButton
              (
                onPressed: () {},
                style: const ButtonStyle(
                    alignment: Alignment.centerLeft,
                  ),
                child: Text("Set first day of the week", style: Theme.of(context).textTheme.bodyMedium)),
              TextButton(
                onPressed: () {},
                style: const ButtonStyle(
                    alignment: Alignment.centerLeft,
                  ),
                child: Text("Currency", style: Theme.of(context).textTheme.bodyMedium)),
              TextButton(
                onPressed: () {},
                style: const ButtonStyle(
                    alignment: Alignment.centerLeft,
                  ),
                child: Text("Language", style: Theme.of(context).textTheme.bodyMedium)),
              TextButton(
                onPressed: () {},
                style: const ButtonStyle(
                    alignment: Alignment.centerLeft,
                  ),
                child: Text("Pin", style: Theme.of(context).textTheme.bodyMedium,),
              ),
              TextButton(
                onPressed: () {},
                style: const ButtonStyle(
                    alignment: Alignment.centerLeft,
                  ),
                child: Text("Reminder", style: Theme.of(context).textTheme.bodyMedium)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Export Data", style: Theme.of(context).textTheme.headlineSmall),
              ),
              TextButton(
                onPressed: () {},
                style: const ButtonStyle(
                    alignment: Alignment.centerLeft,
                  ),
                child: Text("Google Drive", style: Theme.of(context).textTheme.bodyMedium)),
              TextButton(
                onPressed: (){},
                style: const ButtonStyle(
                    alignment: Alignment.centerLeft,
                  ),
                child: Text("Excel", style: Theme.of(context).textTheme.bodyMedium))
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Other", style: Theme.of(context).textTheme.headlineSmall),
              ),
              TextButton(
                onPressed: (){},
                style: const ButtonStyle(
                    alignment: Alignment.centerLeft,
                  ),
                child: Text("Rate the app", style: Theme.of(context).textTheme.bodyMedium)),
            ],
          ),
        ]
      ),
    );
  }
}