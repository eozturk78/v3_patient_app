import 'package:flutter/material.dart';
import 'package:patient_app/apis/apis.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/shared.dart';
import '../../shared/bottom-menu.dart';
import '../../shared/info-box-decoration.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({super.key});
  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  Apis apis = Apis();
  Shared sh = Shared();
  bool isStarted = true;
  var aboutPatient;
  @override
  void initState() {
    super.initState();
    getAboutMe();
  }

  getAboutMe() async {
    setState(() {
      isStarted = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    await apis.patientInfo().then((value) {
      print(value);
      setState(() {
        aboutPatient = value;
        isStarted = false;
      });
    }, onError: (err) {
      setState(() {
        isStarted = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Über mich', context),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Center(
            child: isStarted
                ? Center(
                    child: CircularProgressIndicator(
                    color: mainButtonColor,
                  ))
                : aboutPatient == null
                    ? Center(child: Text("no data found"))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            size: 80,
                            color: iconColor,
                          ),
                          Center(
                            child: Text(
                              '${aboutPatient["firstName"]} ${aboutPatient["lastName"]}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Über mich",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: infoBoxDecoration,
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: iconColor,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(aboutPatient['sex'])
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.cake,
                                      color: iconColor,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(aboutPatient['dateOfBirth'])
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(aboutPatient['comment'] ?? ""),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Kontaktinformationen",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: infoBoxDecoration,
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.email,
                                      color: iconColor,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(aboutPatient['email'] ?? "")
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      color: iconColor,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(aboutPatient['mobilePhone'] ?? "")
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      color: iconColor,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(aboutPatient['phone'] ?? "")
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.home,
                                      color: iconColor,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                        "${aboutPatient['address']} / ${aboutPatient['city']}  / ${aboutPatient['postalCode']}")
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Patientengruppen",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: infoBoxDecoration,
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                for (var item in aboutPatient['patientGroups'])
                                  Column(children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.info,
                                          color: iconColor,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(item['name'])
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ])
                              ],
                            ),
                          )
                        ],
                      ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(0),
    );
  }
}
