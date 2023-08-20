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
    _selectedIndex = widget.selectedIndex ?? -1;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 25.0),
      child: CustomBottomNavigationBar(
        selectedIndex: widget.selectedIndex ?? -1, // Provide a default value
        icons: [
          FontAwesomeIcons.fileMedical,
          FontAwesomeIcons.kitMedical,
          FontAwesomeIcons.message,
          Icons.info_outline,
          Icons.view_cozy_outlined,
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _onItemTapped(index);
          print('Selected index: $index');
        },
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          Navigator.of(context).pushNamedAndRemoveUntil(
              "/main-sub-menu", ModalRoute.withName('/main-menu'));
          break;
        case 1:
          Navigator.of(context).pushNamedAndRemoveUntil(
              "/medication", ModalRoute.withName('/main-menu'));
          break;
        case 2:
          Navigator.of(context).pushNamedAndRemoveUntil(
              "/communication", ModalRoute.withName('/main-menu'));
          break;
        case 3:
          Navigator.of(context).pushNamedAndRemoveUntil(
              "/info", ModalRoute.withName('/main-menu'));
          break;
        case 4:
          Navigator.of(context).pushNamedAndRemoveUntil(
              "/quick-access", ModalRoute.withName('/main-menu'));
          break;
      }
    });
  }
}

class CustomBottomNavigationBar extends StatefulWidget {
  final List<IconData> icons;
  final ValueChanged<int> onTap;
  final int selectedIndex;

  const CustomBottomNavigationBar({
    required this.icons,
    required this.onTap,
    required this.selectedIndex,
  });

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState
    extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(widget.icons.length, (index) {
        return GestureDetector(
          onTap: () {
            widget.onTap(index);
          },
          child: Icon(
            widget.icons[index],
            size: 32.0, // Increase icon size
            color: widget.selectedIndex == index
                ? iconColor // Active color
                : Colors.black, // Inactive color
          ),
        );
      }),
    );
  }
}
