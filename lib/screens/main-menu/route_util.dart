import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../communication/calendar.dart';
import '../communication/chat.dart';
import '../communication/communication.dart';
import '../communication/medical-plan-1.dart';
import '../communication/messages.dart';
import '../home/home.dart';
import '../info/documents-details.dart';
import '../info/documents.dart';
import '../info/enlightenment.dart';
import '../info/info.dart';
import '../info/libraries.dart';
import '../measurement-result/measurement-result-blutdruck.dart';
import '../measurement-result/measurement-result-pulse.dart';
import '../measurement-result/measurement-result-saturation.dart';
import '../measurement-result/measurement-result-temperature.dart';
import '../measurement-result/measurement-result-weight.dart';
import '../medication/medication-plan-list.dart';
import '../medication/medication.dart';
import '../medication/recipes.dart';
import '../patient-contacts/contacts.dart';
import '../profile/about-me/about-me.dart';
import '../profile/profile.dart';
import '../quick-access/quick-access.dart';
import '../settings/settings.dart';
import '../main-menu/main-menu.dart';

class MenuSet {
  String? displayName;
  String? routerName;
  dynamic icon;
  MenuSet(this.displayName, this.icon);
}

final defaultMenuList = [
  "/questionnaire-group",
  "/medication-plan-list",
  "/messages",
  "/notification-history",
  "/info"
];

final Map<String, MenuSet> routeDisplayNames = {
  // "/main-menu": MenuSet('Hauptmenü', Icons.abc),
  //"/settings": MenuSet('Einstellungen', Icons.settings),
  "/home": MenuSet('Grafische Darstellungen',
      SvgPicture.asset('assets/images/menu-icons/graphische-main.svg')),
  //"/profile": MenuSet( 'Profil', SvgPicture.asset('assets/images/menu-icons/profil-main.svg')),
  "/questionnaire-group": MenuSet('Fragebögen',
      SvgPicture.asset('assets/images/menu-icons/tagliche-main.svg')),
  // "/measurement-result": MenuSet('Blutdruckmessergebnisse', Icons.abc),
  // "/measurement-result-weight": MenuSet('Gewichtsergebnisse', Icons.abc),
  // "/measurement-result-pulse": MenuSet('Messergebnisimpuls', Icons.abc),
  // "/measurement-result-temperature":  MenuSet('Messergebnistemperatur', Icons.abc),
  // "/measurement-result-saturation": MenuSet('Sättigungsmessergebnisse', Icons.abc),
  "/communication": MenuSet('Kommunikation',
      SvgPicture.asset('assets/images/menu-icons/nachrichten-main.svg')),
  "/info": MenuSet('Infothek',
      SvgPicture.asset('assets/images/menu-icons/infothek-main.svg')),
  "/medication-plan-list": MenuSet('Medikamentenplan',
      SvgPicture.asset('assets/images/menu-icons/medikation-main.svg')),
  "/messages": MenuSet('Mitteilungen',
      SvgPicture.asset('assets/images/menu-icons/mitteilungen-main.svg')),
  // "/chat": MenuSet('Chat', Icons.abc),
  //"/medical-plan-1": MenuSet('Medizinischer Plan', Icons.abc),
  //"/calendar": MenuSet('Kalender', SvgPicture.asset('assets/images/menu-icons/kalender-main.svg')),
  // "/medication-plan-list": MenuSet('Liste der Medikamentenpläne', Icons.abc),
  "/recipes": MenuSet(
      'Rezepte', SvgPicture.asset('assets/images/menu-icons/rezept-main.svg')),
  "/libraries": MenuSet('Bibliotheken',
      SvgPicture.asset('assets/images/menu-icons/bibliothek-main.svg')),
  "/enlightenment": MenuSet('Aufklärung',
      SvgPicture.asset('assets/images/menu-icons/aufklarung-main.svg')),

  "/documents": MenuSet('Dokumente',
      SvgPicture.asset('assets/images/menu-icons/dokumente-main.svg')),
  // "/document-details": MenuSet('Dokumentdetails', Icons.abc),
  //"/about-me": MenuSet('Über mich', SvgPicture.asset('assets/images/menu-icons/profil-main.svg')),
  "/patient-contacts-list":
      MenuSet('Meine medizinischen Kontakte', Icons.contact_page),
  "/notification-history": MenuSet('Erinnerungen',
      SvgPicture.asset('assets/images/menu-icons/erinnerungen-main.svg')),
};

Map<String, WidgetBuilder> allRoutes = {
  "/main-menu": (context) => const MainMenuPage(),
  "/settings": (context) => const SettingsPage(),
  "/home": (context) => const HomePage(),
  "/profile": (context) => const ProfilePage(),
  "/measurement-result": (context) => const MeasurementResultPage(),
  "/measurement-result-weight": (context) =>
      const MeasurementResultWeightPage(),
  "/measurement-result-pulse": (context) => const MeasurementResultPulsePage(),
  "/measurement-result-temperature": (context) =>
      const MeasurementResultTemperaturePage(),
  "/measurement-result-saturation": (context) =>
      const MeasurementResultSaturationPage(),
  "/communication": (context) => const CommunicationPage(),
  "/info": (context) => const InfoPage(),
  "/medication": (context) => const MedicationPage(),
  "/quick-access": (context) => const QuickAccessPage(),
  "/messages": (context) => const MessagesPage(),
  "/chat": (context) => const ChatPage(),
  "/medical-plan-1": (context) => const MedicalPlan1Page(),
  "/calendar": (context) => CalendarScreen(),
  "/medication-plan-list": (context) => const MedicationPlanListPage(),
  "/recipes": (context) => const RecipesPage(),
  "/libraries": (context) => const LibraryListPage(),
  "/enlightenment": (context) => const EnlightenmentPage(),
  "/documents": (context) => const DocumentListPage(),
  "/document-details": (context) => const DocumentDetailsPage(),
  "/about-me": (context) => const AboutMe(),
  "/patient-contacts-list": (context) => ContactsListingPage(),
};
