import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v3_patient_app/colors/colors.dart';
import 'package:v3_patient_app/shared/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/apis.dart';
import '../../shared/shared.dart';
import '../shared/shared.dart';

class ImpresumPage extends StatefulWidget {
  const ImpresumPage({super.key});
  @override
  State<ImpresumPage> createState() => _ImpresumPageState();
}

class _ImpresumPageState extends State<ImpresumPage> {
  Shared sh = Shared();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    sh.openPopUp(context, 'impresum');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage(sh.getLanguageResource("imprint"), context),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  "assets/images/logo-iMedComV3.png",
                  width: 160,
                  height: 70,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "iMedComV3 GmbH",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Text(
                  "Weinbergweg 23\n06120 Halle an der Saale ",
                ),
                SizedBox(
                  height: 20,
                ),
                Text('${sh.getLanguageResource("tel")} +49 345 57029440'),
                Text(
                    '${sh.getLanguageResource("internet")} https://iMedComV3.de/'),
                Text('${sh.getLanguageResource("email")} info@iMedComV3.de'),
                SizedBox(
                  height: 20,
                ),
                Text(sh.getLanguageResource("address_1")),
                Text(sh.getLanguageResource("register_number")),
                Text(sh.getLanguageResource("address_2")),
                SizedBox(
                  height: 20,
                ),
                Text(sh.getLanguageResource("about_company_1")),
                SizedBox(
                  height: 20,
                ),
                Text(sh.getLanguageResource("about_company_2")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
