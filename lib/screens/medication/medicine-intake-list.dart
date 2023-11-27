import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../apis/apis.dart';
import '../shared/shared.dart';

class MedicineIntakeScreen extends StatefulWidget {
  @override
  _MedicineIntakeScreenState createState() => _MedicineIntakeScreenState();
}

class _MedicineIntakeScreenState extends State<MedicineIntakeScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _morningIntake = false;
  bool _noonIntake = false;
  bool _eveningIntake = false;
  bool _nightIntake = false;

  late Apis api; // Declare an instance of your API class

  @override
  void initState() {
    super.initState();
    api = Apis(); // Initialize your API class instance
    fetchMedicineIntake(); // Fetch medicine intake information when the screen is initialized
  }

  // Replace this with your API call function
  Future<void> saveMedicineIntake() async {
    // Your API call logic to store the information in the database
    print('API call to save medicine intake');
  }

  Future<void> fetchMedicineIntake() async {
    try {
      // Call your API function to fetch medicine intake information
      // Example:
      // final data = await api.fetchMedicineIntake(_selectedDate);
      // Process the data and update the state
      setState(() {
        // Update _morningIntake, _noonIntake, _eveningIntake, _nightIntake based on the fetched data
        // Example:
        // _morningIntake = data['morningIntake'];
        // _noonIntake = data['noonIntake'];
        // _eveningIntake = data['eveningIntake'];
        // _nightIntake = data['nightIntake'];
      });
    } catch (error) {
      // Handle the error
      print('Error fetching medicine intake: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: leadingSubpage('Medicine Intake', context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Datum:",
                      style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 162, 28, 52)),
                    ),
                    Text(
                      DateFormat('dd.MM.yyyy').format(_selectedDate),
                      style: TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.calendar,
                        color: Color.fromARGB(255, 162, 28, 52),
                      ),
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                primaryColor: Color.fromARGB(255, 162, 28, 52),
                                hintColor: Color.fromARGB(255, 162, 28, 52),
                                colorScheme: ColorScheme.light(primary: Color.fromARGB(255, 162, 28, 52)),
                                buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null && picked != _selectedDate) {
                          setState(() {
                            _selectedDate = picked;
                          });
                          fetchMedicineIntake();
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(child: Text("Bestätigung Medikamenteneinnahme")),
              SizedBox(height: 20),
              buildCheckbox('Einnahme morgens', _morningIntake, (bool? value) {
                if (value != null) {
                  setState(() {
                    _morningIntake = value;
                  });
                  saveMedicineIntake();
                }
              }),
              buildCheckbox('Einnahme mittags', _noonIntake, (bool? value) {
                if (value != null) {
                  setState(() {
                    _noonIntake = value;
                  });
                  saveMedicineIntake();
                }
              }),
              buildCheckbox('Einnahme abends', _eveningIntake, (bool? value) {
                if (value != null) {
                  setState(() {
                    _eveningIntake = value;
                  });
                  saveMedicineIntake();
                }
              }),
              buildCheckbox('Einnahme nachts', _nightIntake, (bool? value) {
                if (value != null) {
                  setState(() {
                    _nightIntake = value;
                  });
                  saveMedicineIntake();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCheckbox(String label, bool value, ValueChanged<bool?> onChanged) {
    return GestureDetector(
      onTap: () {
        onChanged(!value); // Toggle the value when the label is tapped
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              width: 24, // Adjust the size of the circular checkbox
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: value ? Color.fromARGB(255, 162, 28, 52) : Colors.transparent,
                border: Border.all(
                  color: Color.fromARGB(255, 162, 28, 52),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: value
                    ? Icon(
                  Icons.check,
                  size: 18,
                  color: Colors.white,
                )
                    : Container(),
              ),
            ),
            SizedBox(width: 8), // Add some spacing between the checkbox and the label
            Text(
              label,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }




}
