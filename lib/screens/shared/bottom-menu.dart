import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../colors/colors.dart';

class BottomNavigatorBar extends StatefulWidget {
  int selectedIndex;
  BottomNavigatorBar(this.selectedIndex, {super.key});
  @override
  State<BottomNavigatorBar> createState() => _CustomMenuButton();
}

class _CustomMenuButton extends State<BottomNavigatorBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          Navigator.of(context).pushNamedAndRemoveUntil("/main-menu", ModalRoute.withName('/main-menu'));
          //widget.selectedIndex=0;
          break;
        case 1:
          Navigator.of(context).pushNamedAndRemoveUntil("/medication", ModalRoute.withName('/main-menu'));
          //widget.selectedIndex=1;
          break;
        case 2:
          Navigator.of(context).pushNamedAndRemoveUntil("/communication", ModalRoute.withName('/main-menu'));
          //widget.selectedIndex=2;
          break;
        case 3:
          Navigator.of(context).pushNamedAndRemoveUntil("/info", ModalRoute.withName('/main-menu'));
          //widget.selectedIndex=3;
          break;
        case 4:
          Navigator.of(context).pushNamedAndRemoveUntil("/quick-access", ModalRoute.withName('/main-menu'));
          //widget.selectedIndex=4;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.fileMedical,
            size: 30,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.kitMedical,
            size: 30,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.message,
            size: 30,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.info_outline,
            size: 30,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.view_cozy_outlined,
            size: 30,
          ),
          label: '',
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: iconColor,
      onTap: _onItemTapped,
    );
  }
}