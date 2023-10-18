import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../model/search-menu.dart';
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
  "/home": MenuSet('Grafische Darstellungen',
      SvgPicture.asset('assets/images/menu-icons/graphische-main.svg')),
  "/questionnaire-group": MenuSet('Fragebögen',
      SvgPicture.asset('assets/images/menu-icons/tagliche-main.svg')),
  "/communication": MenuSet('Kommunikation',
      SvgPicture.asset('assets/images/menu-icons/nachrichten-main.svg')),
  "/info": MenuSet('Infothek',
      SvgPicture.asset('assets/images/menu-icons/infothek-main.svg')),
  "/medication-plan-list": MenuSet('Medikamentenplan',
      SvgPicture.asset('assets/images/menu-icons/medikation-main.svg')),
  "/messages": MenuSet('Mitteilungen',
      SvgPicture.asset('assets/images/menu-icons/mitteilungen-main.svg')),
  "/recipes": MenuSet(
      'Rezepte', SvgPicture.asset('assets/images/menu-icons/rezept-main.svg')),
  "/libraries": MenuSet('Bibliotheken',
      SvgPicture.asset('assets/images/menu-icons/bibliothek-main.svg')),
  "/enlightenment": MenuSet('Aufklärung',
      SvgPicture.asset('assets/images/menu-icons/aufklarung-main.svg')),
  "/documents": MenuSet('Dokumente',
      SvgPicture.asset('assets/images/menu-icons/dokumente-main.svg')),
  "/patient-contacts-list":
      MenuSet('Meine medizinischen Kontakte', Icons.contact_page),
  "/notification-history": MenuSet('Erinnerungen',
      SvgPicture.asset('assets/images/menu-icons/erinnerungen-main.svg')),
};

final searchAllRoutes = [
  SearchMenu(
    displayName: 'Erinnerungen',
    route: '/notification-history',
    type: 'menu',
    icon: SvgPicture.asset('assets/images/menu-icons/erinnerungen-main.svg'),
    keywords: 'Erinnerungen',
  ),
  SearchMenu(
    displayName: 'Auszug meiner Daten',
    route: '/extract-data',
    type: 'menu',
    icon: Icons.data_object,
    keywords:
        'Datenausleitung; Datenexport; Exportfunktion, Auskunft, Datenauskunft,',
  ),
  SearchMenu(
    displayName: 'Meine medizinischen Kontakte',
    route: '/patient-contacts-list',
    type: 'menu',
    icon: SvgPicture.asset('assets/images/menu-icons/nachrichten-main.svg'),
    keywords: 'Kontakte, Meine medizinischen Kontakte,',
  ),
  SearchMenu(
    displayName: 'Meine Diagnosen',
    route: '/diagnoses',
    type: 'menu',
    icon: Icons.contact_page,
    keywords:
        'Diagnosen, Befund, Untersuchung, Krankheitsbefund, Untersuchungsbefund',
  ),
  SearchMenu(
    displayName: 'Über mich',
    route: '/about-me',
    type: 'menu',
    icon: Icons.person,
    keywords: 'Profil; Benutzerprofil',
  ),
  SearchMenu(
    displayName: 'Temperatur - Bedeutung, Messung und Auswirkungen',
    route: '/temperature-description',
    type: 'menu',
    icon: Icons.description,
    keywords: 'Temperatur; Fieber',
  ),
  SearchMenu(
    displayName: 'Was ist die Herzfrequenz?',
    route: '/pulse-description',
    type: 'menu',
    icon: Icons.description,
    keywords: 'Herzfrequenz; Pulsfrequenz',
  ),
  SearchMenu(
    displayName: 'Blutdruck: Was ist das?',
    route: '/blutdruck-description',
    type: 'menu',
    icon: Icons.description,
    keywords: 'Blutdruck',
  ),
  SearchMenu(
    displayName: 'Was ist die Sauerstoffsättigung im Blut?',
    route: '/saturation-description',
    type: 'menu',
    icon: Icons.description,
    keywords: 'Sauerstoffsättigung',
  ),
  SearchMenu(
    displayName: 'Welche Rolle spielt das Körpergewicht?',
    route: '/weight-description',
    type: 'menu',
    icon: Icons.description,
    keywords: 'Körpergewicht; KG; Gewicht',
  ),
  SearchMenu(
    displayName: 'Meine Dokumente',
    route: '/documents',
    type: 'menu',
    icon: SvgPicture.asset('assets/images/menu-icons/dokumente-main.svg'),
    keywords: 'Dokumente; Vollmacht; Briefe; Berichte; Laborberichte, ',
  ),
  SearchMenu(
      displayName: 'Aufklärung',
      route: '/enlightenment',
      type: 'menu',
      icon: SvgPicture.asset('assets/images/menu-icons/aufklarung-main.svg'),
      keywords: 'Aufklärung'),
  SearchMenu(
      displayName: 'Bibliothek',
      route: '/libraries',
      type: 'menu',
      icon: SvgPicture.asset('assets/images/menu-icons/bibliothek-main.svg'),
      keywords: 'Bibliothek'),
  SearchMenu(
      displayName: 'Rezept',
      route: '/recipes',
      type: 'menu',
      icon: SvgPicture.asset('assets/images/menu-icons/rezept-main.svg'),
      keywords: 'Rezept'),
  SearchMenu(
      displayName: 'Medikation',
      route: '/medication',
      type: 'menu',
      icon: SvgPicture.asset('assets/images/menu-icons/medikation-main.svg'),
      keywords: 'Medikation; Medikamentenplan'),
  SearchMenu(
      displayName: 'Kalender',
      route: '/calendar',
      type: 'menu',
      icon: Icons.calendar_month_outlined,
      keywords: 'Kalender'),
  SearchMenu(
      displayName: 'Mitteilungen',
      route: '/messages',
      type: 'menu',
      icon: SvgPicture.asset('assets/images/menu-icons/mitteilungen-main.svg'),
      keywords: 'Mitteilungen; Nachrichten'),
  SearchMenu(
      displayName: 'Medikamentenplan',
      route: '/medication-plan-list',
      type: 'menu',
      icon: SvgPicture.asset('assets/images/menu-icons/medikation-main.svg'),
      keywords: 'Medikation; Medikamentenplan '),
  SearchMenu(
    displayName: 'Infothek',
    route: '/info',
    type: 'menu',
    icon: SvgPicture.asset('assets/images/menu-icons/infothek-main.svg'),
    keywords: 'Infothek',
  ),
  SearchMenu(
      displayName: 'Schnellzugriffsmenü',
      route: '/communication',
      type: 'menu',
      icon: SvgPicture.asset('assets/images/menu-icons/infothek-main.svg'),
      keywords:
          'Sauerstoffsättigung; Sauerstoffgehalt; Grafik, Diagramm; Grafische Darstellungen'),
  SearchMenu(
      displayName: 'Sauerstoffsättigung',
      route: '/measurement-result-saturation',
      type: 'menu',
      icon: SvgPicture.asset('assets/images/menu-icons/graphische-main.svg'),
      keywords: 'Temperatur; Grafik, Diagramm; Grafische Darstellungen'),
  SearchMenu(
      displayName: 'Temperatur',
      route: '/measurement-result-temperature',
      type: 'menu',
      icon: SvgPicture.asset('assets/images/menu-icons/graphische-main.svg'),
      keywords: 'Herzfrequenz; Grafik, Diagramm; Grafische Darstellungen'),
  SearchMenu(
      displayName: 'Herzfrequenz',
      route: '/measurement-result-pulse',
      type: 'menu',
      icon: SvgPicture.asset('assets/images/menu-icons/graphische-main.svg'),
      keywords: 'Gewicht; Grafik, Diagramm; Grafische Darstellungen'),
  SearchMenu(
    displayName: 'Gewicht',
    route: '/measurement-result-weight',
    type: 'menu',
    icon: SvgPicture.asset('assets/images/menu-icons/graphische-main.svg'),
    keywords: 'Gewicht; Grafik, Diagramm; Grafische Darstellungen',
  ),
  SearchMenu(
    displayName: 'Einstellungen',
    route: '/settings',
    type: 'menu',
    icon: Icons.settings,
    keywords: 'Einstellungen',
  ),
  SearchMenu(
    displayName: 'Videosprechstunde',
    route: '/communication',
    type: 'menu',
    icon: Icons.video_call,
    keywords: 'Videosprechstunde, Sprechstunde, Videokonferenz, Call',
  ),
  SearchMenu(
    displayName: 'Tägliche Messungen',
    route: '/questionnaire-group',
    type: 'menu',
    icon: SvgPicture.asset('assets/images/menu-icons/tagliche-main.svg'),
    keywords: 'Tägliche Messungen',
  ),
  SearchMenu(
    displayName: 'Grafische Darstellungen',
    route: '/communication',
    type: 'menu',
    icon: SvgPicture.asset('assets/images/menu-icons/graphische-main.svg'),
    keywords: 'Grafik, Diagramm; Grafische Darstellungen',
  ),
];
