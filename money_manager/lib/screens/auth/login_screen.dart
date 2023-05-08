import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/device_preferences_service';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  
  @override
  void initState(){
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = getHeight(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/welcome_screen_image.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Login", style: Theme.of(context).textTheme.headlineMedium,),
            Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    prefixIcon: Icon(Icons.person),
                    labelText: "Email",
                    hintText: "email",
                    border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: height*0.01),
                TextFormField(
                  decoration: const InputDecoration(  
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    prefixIcon: Icon(Icons.fingerprint),
                    labelText: "Password",
                    hintText: "password",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: null,
                      icon: Icon(Icons.remove_red_eye))
                  ),
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _email.text, 
                      password: _password.text
                    );

                    if(result.user != null){
                      if(!mounted) return;
                      Navigator.of(context).popAndPushNamed("/home/");
                    }
                    else{
                      
                    }
                  }, 
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30)))
                  ),
                  child: const Text("   Login   "),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).popAndPushNamed("/signup/");
                  }, 
                  child: const Text("Don't Nave an Account? Sign up"), 
                ),
              ],
            ),
          ])
        ),
      );
  }
}