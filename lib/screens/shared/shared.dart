import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:patient_app/apis/apis.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../colors/colors.dart';
import '../../model/scale-size.dart';
import '../../shared/shared.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'dart:convert';

class SvgIconData extends IconData {
  const SvgIconData(String assetName, {Key? key})
      : super(
          0xe000, // This is a custom code point, we can use any unused one.
          fontFamily: 'SvgIcons',
          fontPackage: 'iMedComSvgIcons', // package name
          matchTextDirection: true,
        );

  static IconData fromAsset(String assetName) {
    return SvgIconData(assetName);
  }
}

String formatDate(String inputDate) {
  DateTime date = DateTime.parse(
      inputDate); // Convert the input string to a DateTime object
  DateFormat formatter = DateFormat(
      'dd.MM.yyyy'); // Create a formatter with the desired output format
  return formatter
      .format(date); // Format the date and return the formatted string
}

String? getLocalizedGender(String gender, BuildContext context) {
  switch (gender) {
    case 'male':
      return AppLocalizations.tr('male');
    case 'female':
      return AppLocalizations.tr('female');
    case 'other':
      return AppLocalizations.tr('other');
    default:
      return gender; // Return as is if no translation is available
  }
}

class AppLocalizations {
  final Locale locale;
  Map<String, dynamic>? _localizedStrings;

  AppLocalizations._(this.locale);

  static AppLocalizations? _instance;

  static Future<void> load(Locale locale) async {
    String jsonString =
        await rootBundle.loadString('lib/l10n/intl_${locale.languageCode}.arb');
    _instance = AppLocalizations._(locale);
    _instance?._localizedStrings =
        json.decode(jsonString) as Map<String, dynamic>;
  }

  static AppLocalizations get instance {
    if (_instance == null) {
      try {
        AppLocalizations.load(Locale("de", "DE"));
      } catch (e) {
        throw Exception(
            "Localization has not been initialized. Call load() first.");
      }
    }
    return _instance!;
  }

  String? translate(String key) {
    return _localizedStrings?[key] as String?;
  }

  static String tr(String key) {
    return instance.translate(key) ?? key;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Return true if your app supports the given locale
    return [
      'en',
      'de', /* Add other supported locales here */
    ].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // Load the appropriate localization data and create an instance of AppLocalizations
    AppLocalizations.load(locale);
    return AppLocalizations.instance;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

leadingWithoutProfile(String title, BuildContext context) {
  return AppBar(
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () {
        renewToken();
        Navigator.of(context).pop();
      },
    ),
    title: Text(
      title,
      style: TextStyle(color: Colors.black),
    ),
    shadowColor: null,
    elevation: 0.0,
    centerTitle: true,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.white,
  );
}

leading(String title, BuildContext context) {
  return AppBar(
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () => Navigator.of(context).pop(),
    ),
    title: Text(
      title,
      style: TextStyle(color: Colors.black),
    ),
    shadowColor: null,
    elevation: 0.0,
    centerTitle: true,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.white,
  );
}

leadingWithoutBack(String title, BuildContext context) {
  return AppBar(
    centerTitle: false,
    title: Padding(
      padding: EdgeInsets.only(top: 25),
      child: Text(
        title,
        style: TextStyle(
            color: Color.fromARGB(255, 69, 81, 84),
            fontSize: 32,
            fontWeight: FontWeight.bold),
        textAlign: TextAlign.left,
      ),
    ),
    shadowColor: null,
    elevation: 0.0,
    toolbarHeight: 85,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.white,
    actions: <Widget>[
      IconButton(
        icon: const Icon(
          Icons.settings,
          color: Color.fromARGB(255, 69, 81, 84),
        ),
        onPressed: () async {
          await Navigator.of(context).pushNamed("/profile");
        },
      )
    ],
  );
}

leadingWithoutIcon(String title, BuildContext context) {
  // countDownDialog(context);
  return AppBar(
    title: Text(
      title,
      style: TextStyle(color: Colors.black),
    ),
    shadowColor: null,
    elevation: 0.0,
    centerTitle: true,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.white,
  );
}

renewToken() {
  if (tokenTimeOutSecond > 0) tokenTimeOutSecond = tokenTimeOutSecondDB;

  Apis apis = Apis();
  apis.patientrenewtoken().then((value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("token", value['token']);

    tokenTimeOutSecondDB = value['tokenTimeOutSecond'];
    tokenTimeOutSecond = value['tokenTimeOutSecond'];
    popUpAppearSecond = value['popUpAppearSecond'];
  });
}

leadingSubpage(String title, BuildContext context) {
  // countDownDialog(context);
  Shared sh = Shared();
  return AppBar(
    leading: TextButton(
      onPressed: () {
        renewToken();
        Navigator.of(context).pop();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.arrow_back_ios, color: mainButtonColor),
          Text(
            sh.getLanguageResource("back"),
            style: TextStyle(
                color: mainButtonColor,
                fontSize: ResponsiveValue(
                  context,
                  defaultValue: 10.0,
                  conditionalValues: [
                    Condition.largerThan(
                      //Tablet
                      name: MOBILE,
                      value: 16.0,
                    ),
                  ],
                ).value!),
          )
        ],
      ),
    ),
    leadingWidth: 100,
    title: Text(
      title,
      style: TextStyle(
          color: Color.fromARGB(255, 69, 81, 84),
          fontSize: ResponsiveValue(
            context,
            defaultValue: 16.0,
            conditionalValues: [
              Condition.largerThan(
                //Tablet
                name: MOBILE,
                value: 25.0,
              ),
            ],
          ).value!),
      textScaleFactor: ScaleSize.textScaleFactor(context),
    ),
    shadowColor: null,
    elevation: 0.0,
    centerTitle: true,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.white,
  );
}

leadingDescSubpage(String title, BuildContext context) {
  // countDownDialog(context);
  return AppBar(
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () {
        renewToken();
        Navigator.of(context).pop();
      },
    ),
    title: Text(
      title,
      style: TextStyle(color: Colors.black),
    ),
    shadowColor: null,
    elevation: 0.0,
    centerTitle: true,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.white,
    actions: <Widget>[
      IconButton(
        icon: const Icon(
          Icons.person_outline,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed("/profile");
        },
      )
    ],
  );
}

checkPassword(String password) {
  Shared sh = Shared();
  return Column(
    children: [
      Row(
        children: [
          Icon(
            password.length < 10 ? Icons.close : Icons.check,
            color: password.length < 10
                ? Colors.red
                : const Color.fromARGB(255, 1, 61, 32),
          ),
          Flexible(
              child: Text(
            sh.getLanguageResource("must_consists_ten_chars"),
            style: password.length < 10
                ? TextStyle(color: Colors.red)
                : TextStyle(color: const Color.fromARGB(255, 1, 61, 32)),
          ))
        ],
      ),
      Row(
        children: [
          Icon(
            !sh.hasUpperCase(password) ? Icons.close : Icons.check,
            color: !sh.hasUpperCase(password)
                ? Colors.red
                : const Color.fromARGB(255, 1, 61, 32),
          ),
          Flexible(
              child: Text(sh.getLanguageResource("at_least_one_capital_letter"),
                  style: !sh.hasUpperCase(password)
                      ? TextStyle(color: Colors.red)
                      : TextStyle(color: const Color.fromARGB(255, 1, 61, 32))))
        ],
      ),
      Row(
        children: [
          Icon(
            !sh.hasLowerCase(password) ? Icons.close : Icons.check,
            color: !sh.hasLowerCase(password)
                ? Colors.red
                : const Color.fromARGB(255, 1, 61, 32),
          ),
          Flexible(
              child: Text(
                  sh.getLanguageResource("must_contain_at_least_one_lower"),
                  style: !sh.hasLowerCase(password)
                      ? TextStyle(color: Colors.red)
                      : TextStyle(color: const Color.fromARGB(255, 1, 61, 32))))
        ],
      ),
      Row(
        children: [
          Icon(
            !sh.hasSpecialChars(password) ? Icons.close : Icons.check,
            color: !sh.hasSpecialChars(password)
                ? Colors.red
                : const Color.fromARGB(255, 1, 61, 32),
          ),
          Flexible(
              child: Text(
                  sh.getLanguageResource(
                      "must_contain_at_least_symbol_or_number"),
                  style: !sh.hasSpecialChars(password)
                      ? TextStyle(color: Colors.red)
                      : TextStyle(color: const Color.fromARGB(255, 1, 61, 32))))
        ],
      ),
    ],
  );
}

TextStyle selectedPeriod = const TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.black,
  fontSize: 20,
  decoration: TextDecoration.underline,
);

TextStyle articleTitle = const TextStyle(
    fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15);

ButtonStyle descriptionNotStyle = ElevatedButton.styleFrom(
  primary: descriptionNotSelectedButton,
);

TextStyle labelText =
    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

TextStyle selectionLabel = const TextStyle(color: Colors.black, fontSize: 20);

BoxDecoration menuBoxDecoration = BoxDecoration(
  color: Colors.white,
  border: Border.all(
    color: Color.fromARGB(255, 162, 28, 52),
    width: 1,
  ),
  borderRadius: BorderRadius.circular(15),
);

TextStyle agreementHeader = TextStyle(
    fontSize: 20, fontWeight: FontWeight.bold, color: mainButtonColor);

TextStyle agreementSubHeader = TextStyle(
    fontSize: 18, fontWeight: FontWeight.bold, color: mainButtonColor);

TextStyle profileMenuItemColor = TextStyle(
    color: Color.fromARGB(255, 94, 94, 94), fontWeight: FontWeight.normal);

ButtonStyle profileBtnStyle = TextButton.styleFrom(
    padding: EdgeInsets.zero,
    minimumSize: Size(50, 30),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    alignment: Alignment.centerLeft);
openSettingsDialog(BuildContext context, String warningText) {
  Shared sh = Shared();
  return AlertDialog(
      backgroundColor: Color.fromARGB(232, 255, 255, 255),
      insetPadding: const EdgeInsets.all(0),
      actionsPadding: EdgeInsets.all(0),
      content: StatefulBuilder(builder: (BuildContext context, setState) {
        return Container(
          height: 140,
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            children: [
              Text(warningText),
              Column(
                children: [
                  SizedBox(
                    height: 30,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        sh.getLanguageResource("cancel"),
                        style:
                            TextStyle(color: Color.fromARGB(173, 33, 149, 243)),
                      ),
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 30,
                    child: TextButton(
                      onPressed: () {
                        openAppSettings().then((value) => null);
                      },
                      child: Text(
                        sh.getLanguageResource("settings"),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      }));
}

@pragma('vm:entry-point')
Route<Object?> _dialogBuilder(BuildContext context, Object? arguments) {
  Shared sh = Shared();
  return CupertinoDialogRoute<void>(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(sh.getLanguageResource("title")),
        content: Text(sh.getLanguageResource("content")),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(sh.getLanguageResource("yes")),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(sh.getLanguageResource("no")),
          ),
        ],
      );
    },
  );
}
