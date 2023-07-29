import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../colors/colors.dart';
import '../../shared/shared.dart';

leadingWithoutProfile(String title, BuildContext context) {
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

leadingWithoutBack(String title, BuildContext context) {
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

leadingWithoutIcon(String title, BuildContext context) {
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
            "Muss mindestens aus 10 Zeichen bestehen",
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
              child: Text("Muss mindestens einen Großbuchstaben enthalten",
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
              child: Text("Muss mindestens einen Kleinbuchstaben enthalten",
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
              child: Text("Muss mindestens ein Symbol oder Zahl enthalten ",
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
    fontWeight: FontWeight.bold, color: mainItemColor, fontSize: 15);

ButtonStyle descriptionNotStyle = ElevatedButton.styleFrom(
  primary: descriptionNotSelectedButton,
);

TextStyle labelText =
    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

TextStyle selectionLabel = const TextStyle(color: Colors.black, fontSize: 20);

BoxDecoration menuBoxDecoration = BoxDecoration(
  color: mainItemColor,
  border: Border.all(
    color: Color.fromARGB(255, 233, 232, 232),
    width: 1,
  ),
  borderRadius: BorderRadius.circular(15),
  boxShadow: [
    BoxShadow(
      color: Color.fromARGB(255, 189, 187, 187).withOpacity(0.5),
      spreadRadius: 2,
      blurRadius: 2,
      offset: Offset(1, 1), // changes position of shadow
    ),
  ],
);

TextStyle agreementHeader = TextStyle(
    fontSize: 20, fontWeight: FontWeight.bold, color: mainButtonColor);

TextStyle agreementSubHeader = TextStyle(
    fontSize: 18, fontWeight: FontWeight.bold, color: mainButtonColor);
