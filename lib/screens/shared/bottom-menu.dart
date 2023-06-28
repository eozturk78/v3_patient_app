import 'package:flutter/material.dart';

import '../../colors/colors.dart';

class BottomNavigatorBar extends StatefulWidget {
  final int selectedIndex;
  const BottomNavigatorBar(this.selectedIndex, {super.key});
  @override
  State<BottomNavigatorBar> createState() => _CustomMenuButtom();
}

class _CustomMenuButtom extends State<BottomNavigatorBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          Navigator.of(context).pushNamed("/home");
          break;
        case 1:
          Navigator.of(context).pushNamed("/comunication");
          break;
        case 2:
          Navigator.of(context).pushNamed("/medication");
          break;
        case 3:
          Navigator.of(context).pushNamed("/info");
          break;
        case 4:
          Navigator.of(context).pushNamed("/quick-access");
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
            Icons.summarize_outlined,
            size: 30,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.group,
            size: 30,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_box_outlined,
            size: 30,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.description_outlined,
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
