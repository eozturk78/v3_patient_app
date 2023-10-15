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
  ),
  SearchMenu(
    displayName: 'Auszug meiner Daten',
    route: '/extract-data',
    type: 'menu',
    icon: Icons.data_object,
  ),
  SearchMenu(
    displayName: 'Impresum',
    route: '/impresum',
    type: 'menu',
    icon: Icons.info_rounded,
  ),
  SearchMenu(
    displayName: 'Meine medizinischen Kontakte',
    route: '/patient-contacts-list',
    type: 'menu',
    icon: SvgPicture.asset('assets/images/menu-icons/nachrichten-main.svg'),
  ),
  SearchMenu(
    displayName: 'Nutzungsbedingungen',
    route: '/terms-and-conditions',
    type: 'menu',
    icon: Icons.abc,
  ),
  SearchMenu(
    displayName: 'Datenschutzinformation',
    route: '/privacy-policy',
    type: 'menu',
    icon: Icons.policy,
  ),
  SearchMenu(
    displayName: 'Vereinbarungen',
    route: '/agreements',
    type: 'menu',
    icon: Icons.assignment_return,
  ),
  SearchMenu(
    displayName: 'Meine Diagnosen',
    route: '/diagnoses',
    type: 'menu',
    icon: Icons.contact_page,
  ),
  SearchMenu(
    displayName: 'Über mich',
    route: '/about-me',
    type: 'menu',
    icon: Icons.person,
  ),
  SearchMenu(
    displayName: 'Temperatur - Bedeutung, Messung und Auswirkungen',
    route: '/temperature-description',
    type: 'menu',
    icon: Icons.description,
  ),
  SearchMenu(
    displayName: 'Was ist die Herzfrequenz?',
    route: '/pulse-description',
    type: 'menu',
    icon: Icons.description,
  ),
  SearchMenu(
    displayName: 'Blutdruck: Was ist das?',
    route: '/blutdruck-description',
    type: 'menu',
    icon: Icons.description,
  ),
  SearchMenu(
    displayName: 'Was ist die Sauerstoffsättigung im Blut?',
    route: '/saturation-description',
    type: 'menu',
    icon: Icons.description,
  ),
  SearchMenu(
    displayName: 'Welche Rolle spielt das Körpergewicht?',
    route: '/weight-description',
    type: 'menu',
    icon: Icons.description,
  ),
  SearchMenu(
    displayName: 'Meine Dokumente',
    route: '/documents',
    type: 'menu',
    icon: SvgPicture.asset('assets/images/menu-icons/dokumente-main.svg'),
  ),
  SearchMenu(
    displayName: 'Aufklärung',
    route: '/enlightenment',
    type: 'menu',
    icon: SvgPicture.asset('assets/images/menu-icons/aufklarung-main.svg'),
  ),
  SearchMenu(
    displayName: 'Bibliothek',
    route: '/libraries',
    type: 'menu',
    icon: SvgPicture.asset('assets/images/menu-icons/bibliothek-main.svg'),
  ),
  SearchMenu(
    displayName: 'Rezept',
    route: '/recipes',
    type: 'menu',
    icon: SvgPicture.asset('assets/images/menu-icons/rezept-main.svg'),
  ),
  SearchMenu(
    displayName: 'Medikation',
    route: '/medication',
    type: 'menu',
    icon: SvgPicture.asset('assets/images/menu-icons/medikation-main.svg'),
  ),
  SearchMenu(
    displayName: 'Kalender',
    route: '/calendar',
    type: 'menu',
    icon: Icons.calendar_month_outlined,
  ),
  SearchMenu(
    displayName: 'Mitteilungen',
    route: '/messages',
    type: 'menu',
    icon: SvgPicture.asset('assets/images/menu-icons/mitteilungen-main.svg'),
  ),
  SearchMenu(
    displayName: 'Medikamentenplan',
    route: '/medication-plan-list',
    type: 'menu',
    icon: SvgPicture.asset('assets/images/menu-icons/medikation-main.svg'),
  ),
  SearchMenu(
    displayName: 'Infothek',
    route: '/info',
    type: 'menu',
    icon: SvgPicture.asset('assets/images/menu-icons/infothek-main.svg'),
  ),
  SearchMenu(
    displayName: 'Schnellzugriffsmenü',
    route: '/communication',
    type: 'menu',
    icon: SvgPicture.asset('assets/images/menu-icons/infothek-main.svg'),
  ),
  SearchMenu(
    displayName: 'Sauerstoffsättigung',
    route: '/measurement-result-saturation',
    type: 'menu',
    icon: SvgPicture.asset('assets/images/menu-icons/graphische-main.svg'),
  ),
  SearchMenu(
    displayName: 'Temperatur',
    route: '/measurement-result-temperature',
    type: 'menu',
    icon: SvgPicture.asset('assets/images/menu-icons/graphische-main.svg'),
  ),
  SearchMenu(
    displayName: 'Herzfrequenz',
    route: '/measurement-result-pulse',
    type: 'menu',
    icon: SvgPicture.asset('assets/images/menu-icons/graphische-main.svg'),
  ),
  SearchMenu(
    displayName: 'Gewicht',
    route: '/measurement-result-weight',
    type: 'menu',
    icon: SvgPicture.asset('assets/images/menu-icons/graphische-main.svg'),
  ),
  SearchMenu(
    displayName: 'Einstellungen',
    route: '/settings',
    type: 'menu',
    icon: Icons.settings,
  ),
  SearchMenu(
    displayName: 'Passwort ändern',
    route: '/change-password',
    type: 'menu',
    icon: Icons.password,
  ),
  SearchMenu(
    displayName: 'Videosprechstunde',
    route: '/communication',
    type: 'menu',
    icon: Icons.video_call,
  ),
];
