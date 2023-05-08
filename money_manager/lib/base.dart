import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:money_manager/screens/main_screen.dart';
import 'package:money_manager/screens/welcome_screen.dart';
import 'firebase_options.dart';

class Base extends StatefulWidget {
  const Base({super.key});

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {

  @override
  Widget build(BuildContext context)  {
    return FutureBuilder(
        future: Firebase.initializeApp(
                    options: DefaultFirebaseOptions.currentPlatform
                  ), 
        builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot)
        {
          switch(snapshot.connectionState){
            case ConnectionState.done:
              final user = FirebaseAuth.instance;
              if(user.currentUser != null){
                if(user.currentUser!.emailVerified){
                  return const Scaffold();
                }
                else{
                  return const MainScreen();
                }
              }
              else{
                return const WelcomeScreen();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      );
  }
}