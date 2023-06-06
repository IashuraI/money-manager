import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/form_validation.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController _email;
  late final GlobalKey<FormFieldState> _emailField;

  @override
  void initState(){
    _email = TextEditingController();
    _emailField = GlobalKey();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  key: _emailField,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final validator = Validator(
                      validators: [
                        RequiredValidator(),
                        EmailValidator(),
                      ],
                    );

                    return validator.validate(
                      context: context,
                      label: 'Email',
                      value: value,
                    );
                  },
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    prefixIcon: Icon(Icons.person),
                    labelText: "Email",
                    hintText: "email",
                    border: OutlineInputBorder()
                  ),
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if(_emailField.currentState!.validate()){
                      await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: _email.text, 
                      );
                      if(!mounted) return;
                        Navigator.of(context).popAndPushNamed("/login/");
                    }
                  }, 
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30)))
                  ),
                  child: const Text("   Restore password   "),
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