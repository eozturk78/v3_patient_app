import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/shared/toast.dart';
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
      appBar: leadingSubpage('Impresum', context),
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
                  "assets/images/logo-imedcom.png",
                  width: 160,
                  height: 70,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "iMedCom GmbH",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Text(
                  "Weinbergweg 23\n06120 Halle an der Saale ",
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Tel: +49 345 57029440'),
                Text('Internet: https://imedcom.de/'),
                Text('E-Mail: info@imedcom.de'),
                SizedBox(
                  height: 20,
                ),
                Text('Registergericht: Amtsgericht Halle (Saale)'),
                Text('Registernummer: HRB 25641'),
                Text('USt.-Identnr.: DE325355444'),
                SizedBox(
                  height: 20,
                ),
                Text(
                    "Streitbeilegung Die EU-Kommission stellt unter dem Link https://ec.europa.eu/consumers/odr/ eine Online-Streitbeilegungsplattform („OS-Plattform“) bereit. Diese gibt Verbrauchern die Möglichkeit, Streitigkeiten im Zusammenhang mit ihrer Online-Bestellung zunächst ohne Einschaltung eines Gerichts zu klären."),
                SizedBox(
                  height: 20,
                ),
                Text(
                    "Hinweis gemäß § 36 Verbraucherstreitbeilegungsgesetz (VSGB): Die iMedCom GmbH nimmt nicht an einem Streitbeilegungsverfahren vor einer Verbraucherschlichtungsstelle im Sinne des VSBG teil und ist hierzu auch nicht verpflichtet.")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
