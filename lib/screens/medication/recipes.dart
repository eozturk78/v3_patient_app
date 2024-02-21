import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:patient_app/shared/shared.dart';

import '../../apis/apis.dart';
import '../../model/recipe.dart';
import '../shared/bottom-menu.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  Apis apis = Apis();
  Shared sh = Shared();
  List<Recipe>? recipeList;
  bool isStarted = true;
  @override
  void initState() {
    super.initState();
    onGetRecipes();
  }

  onGetRecipes() {
    apis.getPatientRecipes().then((value) {
      setState(() {
        isStarted = false;
        print(value);
        recipeList = (value as List).map((e) => Recipe.fromJson(e)).toList();
        if (recipeList != null && recipeList?.length != 0)
          recipeList![0].isExpanded = true;
      });
    }, onError: (err) {
      sh.redirectPatient(err, context);
      setState(() {
        isStarted = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Rezept', context),
      body: SafeArea(
          // Wrap your body with SafeArea
          child: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
            child: SingleChildScrollView(
                child: isStarted
                    ? CircularProgressIndicator(
                        color: mainButtonColor,
                      )
                    : recipeList != null
                        ? ExpansionPanelList(
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                recipeList![index].isExpanded = !recipeList![index].isExpanded;
                                print(recipeList![index].isExpanded);
                              });
                            },
                            children: [
                                for (var item in recipeList!)
                                  ExpansionPanel(
                                    headerBuilder: (BuildContext context,
                                        bool isExpanded) {
                                      return ListTile(
                                        title: Text(
                                          item.recipeName ?? "",
                                          style: item.isExpanded
                                              ? TextStyle(
                                                  color: iconColor,
                                                  fontWeight: FontWeight.bold)
                                              : TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 75, 74, 74),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(item.createdAt != null
                                            ? sh.formatDateTime(
                                                item.createdAt.toString())
                                            : ""),
                                      );
                                    },
                                    body: Column(
                                      children: [
                                        Image.network(
                                            '${apis.apiPublic}/patient_files/${item.qrCodeImage}'),
                                        ListTile(
                                          subtitle: Column(
                                            children: [
                                              Text(
                                                item.recipeDescription ?? "",
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    isExpanded: item.isExpanded,
                                  )
                              ])
                        : Text("Keine Daten gefunden"))),
      )),
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: 2),
    );
  }
}
