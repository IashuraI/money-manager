import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/device_preferences_service';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _repeatedpassword;

  @override
  void initState(){
    _email = TextEditingController();
    _password = TextEditingController();
    _repeatedpassword = TextEditingController();

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final height = getHeight(context);
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
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
            Text("Register", style: Theme.of(context).textTheme.headlineMedium,),
            Column(
              children: [
                TextFormField(
                  controller: _email,
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
                  controller: _password,
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
                SizedBox(height: height*0.01),
                TextFormField(
                  controller: _repeatedpassword,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    prefixIcon: Icon(Icons.fingerprint),
                    labelText: "Repeat Password",
                    hintText: "Repeat password",
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
                    final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
                  child: const Text(" Sign Up "),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).popAndPushNamed("/login/");
                  }, 
                  child: const Text("Already Have an Account? Login"), ),
              ],
            ),
          ])
        ),
      );
  }
}