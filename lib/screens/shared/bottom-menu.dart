import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:patient_app/colors/colors.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Daten',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Medikation',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.messenger_outline),
          label: 'Nachrichten',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'Infothek',
        ),
      ],
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.grey,
      currentIndex: _selectedIndex,
      selectedItemColor: mainButtonColor,
      iconSize: 16,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      onTap: _onItemTapped,
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
