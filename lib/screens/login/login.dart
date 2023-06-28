import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool remeberMeState = false;
  bool check1 = false;
  bool check2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 70,
              ),
              Image.asset(
                "assets/images/logo-imedcom.png",
                width: 200,
                height: 100,
              ),
              const SizedBox(
                height: 70,
              ),
              TextFormField(
                obscureText: false,
                decoration: const InputDecoration(
                  labelText: 'User name',
                ),
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: remeberMeState,
                    onChanged: ((value) => setState(() {
                          remeberMeState = !remeberMeState;
                        })),
                  ),
                  Text("Remember me"),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  primary: mainButtonColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed("/home");
                },
                child: const Text("Send"),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Checkbox(
                    value: check1,
                    onChanged: ((value) => setState(() {
                          check1 = !check1;
                        })),
                  ),
                  Text("I agree the terms and conditions."),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: check2,
                    onChanged: ((value) => setState(() {
                          check2 = !check2;
                        })),
                  ),
                  const Expanded(
                    child: Text(
                      "I consent to the processing of my personal data within the scope of using the app in accordance with the privacy statement [enter the link to privacy statement]. I can revoke my consent with effect for the future at any time",
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
