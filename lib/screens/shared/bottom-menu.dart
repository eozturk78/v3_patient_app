import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient_app/apis/apis.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/medication/interactive-medication-plan.dart';
import 'package:patient_app/shared/shared.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:responsive_framework/responsive_value.dart';

import 'package:badges/badges.dart' as badges;

int? unreadMessageCount;

class BottomNavigatorBar extends StatefulWidget {
  final int? selectedIndex;

  BottomNavigatorBar({this.selectedIndex, Key? key}) : super(key: key);

  @override
  State<BottomNavigatorBar> createState() => _CustomMenuButtonState();
}

class _CustomMenuButtonState extends State<BottomNavigatorBar> {
  late int _selectedIndex;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex ?? 0;

    getUnReadMessageCount();
  }

  getUnReadMessageCount() {
    Apis apis = Apis();

    apis.getUnReadMessageCount().then((value) {
      setState(() {
        unreadMessageCount = value['unreadmessagecount'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Shared sh = Shared();
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: _buildNavItem('assets/images/home.svg',
              sh.getLanguageResource("home"), 0, null),
          label: sh.getLanguageResource("home"),
        ),
        BottomNavigationBarItem(
          icon: _buildNavItem('assets/images/daten.svg',
              sh.getLanguageResource("data"), 1, null),
          label: sh.getLanguageResource("data"),
        ),
        BottomNavigationBarItem(
            icon: _buildNavItem('assets/images/medikation.svg',
                sh.getLanguageResource("medication"), 2, null),
            label: sh.getLanguageResource("medication")),
        BottomNavigationBarItem(
          icon: _buildNavItem('assets/images/messenger_outline.svg',
              sh.getLanguageResource("communication"), 3, unreadMessageCount),
          label: sh.getLanguageResource("communication"),
        ),
        BottomNavigationBarItem(
          icon: _buildNavItem('assets/images/info.svg',
              sh.getLanguageResource("info_tech"), 4, null),
          label: sh.getLanguageResource("info_tech"),
        ),
      ],
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.grey,
      currentIndex: _selectedIndex,
      selectedItemColor: mainButtonColor,
      iconSize: ResponsiveValue(
        context,
        defaultValue: 16.0,
        conditionalValues: [
          Condition.largerThan(
            //Tablet
            name: MOBILE,
            value: 20.0,
          ),
        ],
      ).value!,
      selectedFontSize: ResponsiveValue(
        context,
        defaultValue: 12.0,
        conditionalValues: [
          Condition.largerThan(
            //Tablet
            name: MOBILE,
            value: 16.0,
          ),
        ],
      ).value!,
      unselectedFontSize: ResponsiveValue(
        context,
        defaultValue: 12.0,
        conditionalValues: [
          Condition.largerThan(
            //Tablet
            name: MOBILE,
            value: 16.0,
          ),
        ],
      ).value!,
      onTap: _onItemTapped,
    );
  }

  Widget _buildNavItem(
      String assetName, String label, int index, int? unReadMessageCount) {
    final isSelected = index == _selectedIndex;
    final color = isSelected ? mainButtonColor : Colors.grey;

    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: badges.Badge(
              badgeStyle: badges.BadgeStyle(
                  padding: EdgeInsets.all(4),
                  badgeColor:
                      unReadMessageCount == null || unReadMessageCount == 0
                          ? Colors.transparent
                          : Colors.red),
              badgeContent: unReadMessageCount != null
                  ? Text(
                      unreadMessageCount.toString(),
                      style: TextStyle(
                          color: unReadMessageCount == 0 ||
                                  unReadMessageCount == "0"
                              ? Colors.transparent
                              : Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    )
                  : null,
              child: SvgPicture.asset(
                assetName,
                height: 20,
                color: color, // Set the color based on selection
              ),
            )),
        if (isSelected)
          Positioned(
            bottom: 0,
            child: Container(
              width: 0,
              height: 0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: mainButtonColor, // Set the color for the indicator dot
              ),
            ),
          ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.of(context).pushNamedAndRemoveUntil(
              "/main-menu", ModalRoute.withName('/main-menu'));
          break;
        case 1:
          Navigator.of(context).pushNamedAndRemoveUntil(
              "/main-sub-menu", ModalRoute.withName('/main-menu'));
          break;
        case 2:
          Navigator.of(context).pushNamedAndRemoveUntil(
              "/medication", ModalRoute.withName('/main-menu'));
          break;
        case 3:
          Navigator.of(context).pushNamedAndRemoveUntil(
              "/communication", ModalRoute.withName('/main-menu'));
          break;
        case 4:
          Navigator.of(context).pushNamedAndRemoveUntil(
              "/info", ModalRoute.withName('/main-menu'));
          break;
      }
    });
  }
}
