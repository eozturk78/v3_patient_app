import 'package:flutter/material.dart';

import '../../colors/colors.dart';

leading(String title, BuildContext context) {
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

leadingSubpage(String title, BuildContext context) {
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

leadingDescSubpage(String title, BuildContext context) {
  return AppBar(
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () => Navigator.of(context).pushNamed("/home"),
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

TextStyle selectedPeriod = TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.black,
  fontSize: 20,
  decoration: TextDecoration.underline,
);

TextStyle articleTitle =
    TextStyle(fontWeight: FontWeight.bold, color: mainItemColor, fontSize: 15);

ButtonStyle descriptionNotStyle = ElevatedButton.styleFrom(
  primary: descriptionNotSelectedButton,
);
