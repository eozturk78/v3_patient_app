import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';

class CustomMedicationPlanBox extends StatelessWidget {
  final String nameOfMP;
  String? dateTime;
  final String doctor;
  CustomMedicationPlanBox(this.nameOfMP, this.dateTime, this.doctor,
      {super.key});

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
                    Icons.picture_as_pdf,
                    color: iconColor,
                    size: 60,
                  ),
                ),
                Text(
                  "Name des Dokuments",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  nameOfMP,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Erstelldatum",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  dateTime ?? "",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Ersteller des Medikamentenplans",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  doctor,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
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
