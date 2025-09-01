import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v3_patient_app/colors/colors.dart';
import '../../apis/apis.dart';
import '../../shared/shared.dart';
import '../shared/shared.dart';

class Registration1Page extends StatefulWidget {
  const Registration1Page({super.key});
  @override
  State<Registration1Page> createState() => _Registration1PageState();
}

class _Registration1PageState extends State<Registration1Page> {
  final _formKey = GlobalKey<FormState>();
  Shared sh = new Shared();
  Apis apis = new Apis();
  bool remeberMeState = false;
  bool check1 = false;
  bool check2 = false;
  bool check3 = false;
  bool check4 = false;
  bool isSendEP = false;
  @override
  void initState() {
    // TODO: implement initState
    checkRemeberMe();
    super.initState();
  }

  checkRemeberMe() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingWithoutProfile(
          sh.getLanguageResource("registration_1"), context),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
              child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  sh.getLanguageResource("agreement_4"),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: mainButtonColor),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Checkbox(
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return mainButtonColor; // Set to your login button color
                          }
                          return Color.fromARGB(136, 241, 241,
                              241); // Change to your desired unselected color
                        },
                      ),
                      onChanged: (value) {
                        setState(() {
                          check1 = !check1;
                        });
                      },
                      value: check1,
                    ),
                    Flexible(
                        child: Text(
                      sh.getLanguageResource("older_than_eighteen"),
                      style: TextStyle(fontSize: 16),
                    ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Checkbox(
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return mainButtonColor; // Set to your login button color
                          }
                          return Color.fromARGB(136, 241, 241,
                              241); // Change to your desired unselected color
                        },
                      ),
                      onChanged: (value) {
                        setState(() {
                          check2 = !check2;
                        });
                      },
                      value: check2,
                    ),
                    Flexible(
                      child: Text(
                        sh.getLanguageResource("i_agree_use"),
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  sh.getLanguageResource("agreement_1"),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: mainButtonColor),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Checkbox(
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return mainButtonColor; // Set to your login button color
                          }
                          return Color.fromARGB(136, 241, 241,
                              241); // Change to your desired unselected color
                        },
                      ),
                      onChanged: (value) {
                        setState(() {
                          check3 = !check3;
                        });
                      },
                      value: check3,
                    ),
                    Flexible(
                        child: Text(
                      sh.getLanguageResource("agreement_2"),
                      style: TextStyle(fontSize: 16),
                    ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Checkbox(
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return mainButtonColor; // Set to your login button color
                          }
                          return Color.fromARGB(136, 241, 241,
                              241); // Change to your desired unselected color
                        },
                      ),
                      onChanged: (value) {
                        setState(() {
                          check4 = !check4;
                        });
                      },
                      value: check4,
                    ),
                    Flexible(
                        child: Text(
                      sh.getLanguageResource("imedcom_info_2"),
                      style: TextStyle(fontSize: 16),
                    ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    backgroundColor: mainButtonColor,
                  ),
                  onPressed: () async {
                    if (check1 && check2 && check3 && check4) {
                      Navigator.of(context).pushNamed('/registration-2');
                    }
                  },
                  child: Text(sh.getLanguageResource("further")),
                )
              ],
            ),
          )),
        ),
      ),
    );
  }
}
