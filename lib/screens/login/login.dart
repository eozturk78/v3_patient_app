import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/apis.dart';
import '../../shared/shared.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userNameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Shared sh = new Shared();
  Apis apis = new Apis();
  bool remeberMeState = false;
  bool check1 = false;
  bool check2 = false;

  @override
  void initState() {
    // TODO: implement initState
    checkRemeberMe();
    super.initState();
  }

  checkRemeberMe() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("rememberMe") == true.toString()) {
      remeberMeState = true;
      userNameController.text = pref.getString("userName")!;
      passwordController.text = pref.getString("password")!;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                  controller: userNameController,
                  obscureText: false,
                  decoration: const InputDecoration(
                    labelText: 'User name',
                  ),
                  validator: (text) => sh.textValidator(text),
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  validator: (text) => sh.textValidator(text),
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
                  onPressed: () async {
                    final isValid = _formKey.currentState?.validate();
                    if (!isValid!) return;

                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    if (remeberMeState) {
                      pref.setString("rememberMe", true.toString());
                      pref.setString("userName", userNameController.text);
                      pref.setString("password", passwordController.text);
                    } else {
                      pref.clear();
                    }
                    await apis
                        .login(userNameController.text, passwordController.text)
                        .then((value) async {
                      if (value != null) {
                        pref.setString('token', value['token']);

                        await apis.patientInfo().then((value) {
                          var p = sh.getBaseName(value['links']['self']);
                          pref.setString('patientId', '${p}');
                          pref.setString('patientTitle',
                              '${value["firstName"]} ${value["lastName"]}');
                          Navigator.of(context).pushReplacementNamed("/home");
                        });
                      }
                    });
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
      ),
    );
  }
}
