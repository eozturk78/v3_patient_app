import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:v3_patient_app/colors/colors.dart';
import 'package:v3_patient_app/model/organization.dart';
import 'package:v3_patient_app/shared/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/apis.dart';
import '../../shared/shared.dart';
import '../shared/shared.dart';

class Registration2Page extends StatefulWidget {
  const Registration2Page({super.key});
  @override
  State<Registration2Page> createState() => _Registration2PageState();
}

class _Registration2PageState extends State<Registration2Page> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String qrText = '';
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  Shared sh = new Shared();
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

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code!;
        print(qrText);
        getMobileOrganizationInfo(qrText);
      });
    });
  }

  Organization? organizationInfo;
  getMobileOrganizationInfo(String organizationId) async {
    Apis apis = Apis();
    SharedPreferences pref = await SharedPreferences.getInstance();
    apis.getMobileOrganizationInfo(organizationId).then((value) {
      organizationInfo = Organization.fromJson(value);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingWithoutProfile(
          sh.getLanguageResource("registration_1"), context),
      body: organizationInfo == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sh.getLanguageResource(
                            "please_scan_qrcode_organization"),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: mainButtonColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          sh.getLanguageResource(
                              "please_scan_qrcode_organization_desc"),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                )
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        organizationInfo!.organizationTitle,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: mainButtonColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(organizationInfo!.address,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(organizationInfo!.email,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(organizationInfo!.phoneNumber,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 100),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                          backgroundColor: mainButtonColor,
                        ),
                        onPressed: () async {
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.setInt('organizationId',
                              organizationInfo!.organizationId!);
                          Navigator.of(context).pushNamed('/registration-3');
                        },
                        child: Text(sh.getLanguageResource("further")),
                      ),
                      SizedBox(height: 50),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                          backgroundColor: mainItemColor,
                        ),
                        onPressed: () async {
                          organizationInfo = null;
                          setState(() {});
                        },
                        child: Text(sh
                            .getLanguageResource("scan_another_organization")),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
