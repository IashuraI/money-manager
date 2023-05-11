import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/form_validation.dart';
import '../../services/device_preferences_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  late bool _passwordVisible;
  
  late final GlobalKey<FormFieldState> _emailField;

  @override
  void initState(){
    _email = TextEditingController();
    _password = TextEditingController();

    _passwordVisible = true;

    _emailField = GlobalKey();

    super.initState();
  }

  void toggle() {
      setState(() {
        _passwordVisible = !_passwordVisible;
      });
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
                SizedBox(height: height*0.01),
                TextFormField(
                  controller: _password,
                  obscureText: _passwordVisible,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    prefixIcon: const Icon(Icons.fingerprint),
                    labelText: "Password",
                    hintText: "password",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_passwordVisible ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        toggle();
                      },
                    )),
                  ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if(_emailField.currentState!.validate()){
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _email.text, 
                        password: _password.text
                      );
                      if(!mounted) return;
                        Navigator.of(context).popAndPushNamed("/home/");
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