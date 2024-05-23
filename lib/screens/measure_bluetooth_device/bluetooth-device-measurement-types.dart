import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/model/questionnaire-group.dart';
import 'package:patient_app/screens/main-menu/main-menu.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../apis/apis.dart';
import '../../shared/shared.dart';

class BluetoothDeviceMeasurementTypesPage extends StatefulWidget {
  const BluetoothDeviceMeasurementTypesPage({super.key});

  @override
  State<BluetoothDeviceMeasurementTypesPage> createState() =>
      _BluetoothDeviceMeasurementTypesPageState();
}

class _BluetoothDeviceMeasurementTypesPageState
    extends State<BluetoothDeviceMeasurementTypesPage> {
  Apis apis = Apis();
  List<QuestionnaireGroup> questionnaireGroups = [];
  bool isStarted = true;
  PDFDocument? document;
  String? imageUrl;
  bool isPdf = false;
  Shared sh = Shared();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Shared sh = new Shared();
    return Scaffold(
      appBar:
          leadingSubpage(sh.getLanguageResource("measurement_types"), context),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width *
                ResponsiveValue(
                  context,
                  defaultValue: 1,
                  conditionalValues: [
                    Condition.largerThan(
                      //Tablet
                      name: MOBILE,
                      value: 0.7,
                    ),
                  ],
                ).value!,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                width: double.infinity,
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  verticalDirection: VerticalDirection.down,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context)
                                .pushNamed('/bluetooth-blood-pressure');
                          },
                          child: Row(
                            children: [
                              Text(
                                sh.getLanguageResource("blood_pressure"),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: ResponsiveValue(
                                      context,
                                      defaultValue: 12.0,
                                      conditionalValues: [
                                        Condition.largerThan(
                                          //Tablet
                                          name: MOBILE,
                                          value: 20.0,
                                        ),
                                      ],
                                    ).value!),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: mainButtonColor,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                        Divider(
                          height: 40,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
