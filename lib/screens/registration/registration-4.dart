import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:v3_patient_app/colors/colors.dart';
import 'package:v3_patient_app/model/country.dart';
import 'package:v3_patient_app/model/postalCode.dart';
import 'package:v3_patient_app/shared/toast.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../apis/apis.dart';
import '../../shared/shared.dart';
import '../shared/shared.dart';

class Registration4Page extends StatefulWidget {
  const Registration4Page({super.key});
  @override
  State<Registration4Page> createState() => _Registration4PageState();
}

class _Registration4PageState extends State<Registration4Page> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController streetController = new TextEditingController();
  TextEditingController houseNumberController = new TextEditingController();

  TextEditingController postalCodeContrller = new TextEditingController();
  TextEditingController mobilePhoneNumberController =
      new TextEditingController();
  Shared sh = new Shared();

  Apis apis = Apis();

  List<Country> countryList = [];
  List<City> cityList = [];
  bool isSendEP = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onGetCountryList();
  }

  checkRemeberMe() async {
    setState(() {});
  }

  onGetCountryList() async {
    setState(() {
      isSendEP = true;
    });
    apis.getCountryList().then(
      (resp) {
        if (resp != null) {
          setState(() {
            isSendEP = false;
            countryList =
                (resp as List).map((e) => Country.fromJson(e)).toList();
            cityList = countryList
                .where((a) => a.countryId == selectedCountryId)
                .first
                .cities;

            onGetPostalCodeListByCity(selectedCityId!);
          });
        }
      },
      onError: (err) {
        sh.redirectPatient(err, context);
        setState(
          () {
            isSendEP = false;
          },
        );
      },
    );
  }

  List<PostalCode> postalCodeList = [];
  onGetPostalCodeListByCity(int cityId) {
    apis.getPostalCodeListByCity(cityId).then(
      (resp) {
        if (resp != null) {
          print(resp);
          postalCodeList =
              (resp as List).map((e) => PostalCode.fromJson(e)).toList();
        }
      },
      onError: (err) {
        sh.redirectPatient(err, context);
        setState(
          () {
            isSendEP = false;
          },
        );
      },
    );
  }

  PhoneNumber number = PhoneNumber(isoCode: 'DE');

  int selectedCountryId = 79;
  int? selectedCityId = 1041;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingWithoutProfile(
          sh.getLanguageResource("registration_3"), context),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: isSendEP
            ? Center(
                child: Container(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    color: mainButtonColor,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sh.getLanguageResource("personalisation"),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: mainButtonColor),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          sh.getLanguageResource("let_us_customise"),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        Text(
                          sh.getLanguageResource("country"),
                          style: labelText,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: DropdownButton<int>(
                            value: selectedCountryId,
                            onChanged: (newValue) {
                              setState(() {
                                selectedCountryId = newValue!;
                                cityList = countryList
                                    .where(
                                        (a) => a.countryId == selectedCountryId)
                                    .first
                                    .cities;
                              });
                            },
                            isExpanded: true,
                            items: countryList
                                .map((item) => DropdownMenuItem(
                                      child: Text(
                                        item.countryName,
                                      ),
                                      value: item.countryId,
                                    ))
                                .toList(),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          sh.getLanguageResource("city"),
                          style: labelText,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: DropdownButton<int>(
                            value: selectedCityId,
                            onChanged: (newValue) {
                              setState(() {
                                selectedCityId = newValue!;
                                onGetPostalCodeListByCity(selectedCityId!);
                              });
                            },
                            isExpanded: true,
                            items: cityList
                                .map((item) => DropdownMenuItem(
                                      child: Text(
                                        item.cityName,
                                      ),
                                      value: item.cityId,
                                    ))
                                .toList(),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sh.getLanguageResource("street"),
                                    style: labelText,
                                  ),
                                  TextFormField(
                                    controller: streetController,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: sh.getLanguageResource(
                                          "please_enter_street"),
                                    ),
                                    validator: (text) => sh.textValidator(text),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sh.getLanguageResource("house_number"),
                                    style: labelText,
                                  ),
                                  TextFormField(
                                    controller: houseNumberController,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: sh.getLanguageResource(
                                          "please_enter_house_number"),
                                    ),
                                    validator: (text) => sh.textValidator(text),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                            color: const Color.fromARGB(255, 134, 134, 134)),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          sh.getLanguageResource("postal_code"),
                          style: labelText,
                        ),
                        TextFormField(
                          controller: postalCodeContrller,
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: sh.getLanguageResource(
                                "please_enter_postal_code"),
                          ),
                          validator: (value) {
                            if (value!.isNotEmpty &&
                                postalCodeList.length > 0 &&
                                postalCodeList
                                    .where((a) => a.postalCode == value)
                                    .isEmpty) {
                              return "Ungültige Postleitzahl";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                            color: const Color.fromARGB(255, 134, 134, 134)),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          sh.getLanguageResource("phone_number"),
                          style: labelText,
                        ),
                        InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber num) {
                            number = num;
                          },
                          selectorConfig: SelectorConfig(
                            selectorType: PhoneInputSelectorType.DIALOG,
                            setSelectorButtonAsPrefixIcon:
                                true, // ✅ bayrak hizalanır
                            leadingPadding: 0,
                          ),
                          initialValue: number,
                          textFieldController: mobilePhoneNumberController,
                          inputDecoration: InputDecoration(
                            hintText: sh.getLanguageResource(
                                "please_enter_phone_number"),
                            border: InputBorder.none,
                            isDense:
                                true, // ✅ input'u küçültüp hizalar/ ✅ dikey hizalama
                          ),
                          validator: (value) => sh.textValidator(value),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(40),
                            backgroundColor: mainButtonColor,
                          ),
                          onPressed: () async {
                            final isValid = _formKey.currentState?.validate();
                            if (!isValid! || isSendEP) return;
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();

                            pref.setInt('countryId', selectedCountryId);
                            pref.setInt('cityId', selectedCityId!);
                            pref.setString('street', streetController.text);
                            pref.setString(
                                'houseNumber', houseNumberController.text);
                            pref.setString(
                                'postalCode', postalCodeContrller.text);
                            pref.setString('mobilePhoneNumber',
                                mobilePhoneNumberController.text);
                            Navigator.of(context).pushNamed('/registration-5');
                          },
                          child: Text(sh.getLanguageResource("further")),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
