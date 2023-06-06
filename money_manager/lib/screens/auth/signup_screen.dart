import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/form_validation.dart';
import '../../services/device_preferences_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _repeatedpassword;

  late final GlobalKey<FormFieldState> _emailField;

  late bool _passwordVisible;

  @override
  void initState(){
    _email = TextEditingController();
    _password = TextEditingController();
    _repeatedpassword = TextEditingController();

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
                SizedBox(height: height*0.01),
                TextFormField(
                  controller: _repeatedpassword,
                  obscureText: _passwordVisible,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    prefixIcon: const Icon(Icons.fingerprint),
                    labelText: "Repeat Password",
                    hintText: "Repeat password",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_passwordVisible ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        toggle();
                      },
                    )
                  ),
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String? content;
                    if (_emailField.currentState!.validate()) {
                      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: _email.text, 
                        password: _password.text
                      ).catchError((e){
                        content = e.toString();
                      });
                    
                      if(context.mounted){
                        await showDialog(
                          context: context, 
                          builder: (context) {

                          Widget okButton = TextButton(
                            child: const Text("OK"),
                            onPressed:  () {
                              Navigator.of(context).pop();
                              Navigator.of(context).popAndPushNamed("/login/");
                            },
                          );

                          if(result.user != null){
                            content = "Please confirm your email adress. Check your inbox or spam";

                            result.user!.sendEmailVerification();
                          }

                          AlertDialog alert = AlertDialog(
                            title: const Text("Confirmation"),
                            content: Text(content!),
                            actions: [
                              okButton,
                            ],
                          );

                          return alert;
                        });
                      }
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