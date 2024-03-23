import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/shared/shared.dart';

class CustomDiagnoseBox extends StatelessWidget {
  final String diagnoseName;
  final String subDiagnoseName;
  final int securedDiagnoseG;
  final int suspicionV;
  final int exclusionA;
  final int stateAfter;
  final int diaLeft;
  final int diaRight;
  final int bothSide;
  String? dateTime;
  final String doctor;
  CustomDiagnoseBox(
    this.diagnoseName,
    this.subDiagnoseName,
    this.securedDiagnoseG,
    this.suspicionV,
    this.exclusionA,
    this.diaLeft,
    this.diaRight,
    this.bothSide,
    this.dateTime,
    this.stateAfter,
    this.doctor, {
    super.key,
  });
  Shared sh = Shared();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: const EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 30),
            width: MediaQuery.of(context).size.width,
            constraints: const BoxConstraints(
              maxHeight: double.infinity,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromARGB(255, 233, 232, 232),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Icon(
                    Icons.medical_services_outlined,
                    color: iconColor,
                    size: 60,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(this.diagnoseName),
                SizedBox(
                  height: 10,
                ),
                Text(this.subDiagnoseName),
                SizedBox(
                  height: 20,
                ),
                Wrap(
                  runSpacing: 5.0,
                  spacing: 5.0,
                  children: [
                    if (this.securedDiagnoseG == 1)
                      Text(sh.getLanguageResource("secured_diagnose_g"),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey)),
                    if (this.suspicionV == 1)
                      Text(sh.getLanguageResource("susp_v"),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey)),
                    if (this.exclusionA == 1)
                      Text(sh.getLanguageResource("exlusion_a"),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey)),
                    if (this.stateAfter == 1)
                      Text(sh.getLanguageResource("condition_after_a"),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Wrap(
                  runSpacing: 5.0,
                  spacing: 5.0,
                  children: [
                    if (this.diaLeft == 1)
                      Text(sh.getLanguageResource("left"),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey)),
                    if (this.diaRight == 1)
                      Text(sh.getLanguageResource("right"),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey)),
                    if (this.bothSide == 1)
                      Text(sh.getLanguageResource("on_both_sides"),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey)),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  doctor,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  dateTime != null ? sh.formatDateTime(dateTime!) : "",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )),
        SizedBox(
          height: 2,
        )
      ],
    );
  }
}
