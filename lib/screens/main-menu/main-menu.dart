import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';
import '../../model/patient-file.dart';
import '../../model/search-menu.dart';
import '../communication/calendar.dart';
import '../shared/bottom-menu.dart';
import '../shared/custom_menu.dart';
import '../../apis/apis.dart';
import '../../shared/shared.dart';
import '../shared/shared.dart';
import '../shared/sub-total.dart';
import 'route_util.dart';
import '../shared/customized_menu.dart'; // Import the customized_menu.dart file

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({Key? key}) : super(key: key);

  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> with RouteAware {
  int _selectedIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentModalRoute = ModalRoute.of(context);
    if (currentModalRoute != null) {
      // Check if currentModalRoute is not null
      routeObserver.subscribe(this, currentModalRoute);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // Implement the RouteAware methods
  @override
  void didPopNext() {
    // This method is called when a route is popped (subpage is closed)
    // We can execute logic here when the user returns to this page
    setState(() {
      _loadMenuItems();
      _selectedIndex = 0;
    });
    //print('User returned to MainMenuPage');
  }

  Apis apis = Apis();
  Shared sh = Shared();
  Key _refreshKey = UniqueKey();

  String title = "";
  List<MenuSet> _menuItems = []; // Store all menu items

  @override
  void initState() {
    super.initState();
    getPatientInfo();

    _loadMenuItems(); // Load menu items from shared preferences
  }

  void _loadMenuItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? selectedRouteNamesJson = prefs.getString('selectedMenuItems');
    print("stored data");
    print(selectedRouteNamesJson);
    setState(() {
      if (selectedRouteNamesJson != null && selectedRouteNamesJson != '') {
        List<dynamic> selectedRouteNames = jsonDecode(selectedRouteNamesJson!);

        _menuItems.clear();
        selectedRouteNames.forEach((element) {
          if (element['isSelected'] == true) {
            if (routeDisplayNames.entries
                    .where((x) => x.key == element['routeName'])
                    .length >
                0) {
              var p = routeDisplayNames.entries
                  .where((x) => x.key == element['routeName'])
                  .first;
              p.value.routerName = element['routeName'];
              _menuItems.add(p.value);
            }
          }
        });
      } else {
        _menuItems.clear();
        defaultMenuList.forEach((element) {
          print(element);
          var p =
              routeDisplayNames.entries.where((x) => x.key == element).first;
          p.value.routerName = element;
          _menuItems.add(p.value);
        });
      }
      _refreshKey = UniqueKey();
      //print(_refreshKey);
    });
  }

  getPatientInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      //pref.setString('selectedMenuItems', ''); // To reset quick menu items
      title = pref.getString('patientTitle')!;
      pref.setString("patientTitle", title);
    });
    await apis.patientInfo().then((value) {
      //print(value);
      setState(() {
        pref.setString("patientGroups", jsonEncode(value['patientGroups']));
      });
    }, onError: (err) {
      sh.redirectPatient(err, context);
      setState(() {});
    });
  }

  onsearchfunction(searchText) {
    apis.getSearchFunctions(searchText).then((resp) {
      var r = (resp as List).map((e) => SearchMenu.fromJson(e)).toList();
      setState(() {
        r.forEach((x) {
          filteredRouters.add(x);
        });
      });
      if (_searchText == "") filteredRouters = [];
    });
  }

  onClickSearchFunctionResult(item) async {
    if (item.type == 'menu')
      Navigator.of(context).pushNamed(item.route!);
    else if (item?.type == 'folder') {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('folderId', item.id.toString());
      pref.setString('folderName', item.displayName);
      Navigator.of(context).pushNamed('/document-details').then((value) {
        setState(() {});
      });
    } else if (item.type == 'file') {
      onOpenFile(item);
    }
  }

  bool isPdf = false;
  PDFDocument? document;
  String? imageUrl;
  onOpenFile(item) async {
    var fileUrl = "";

    fileUrl = '${apis.apiPublic}/patient_files/${item.id}';

    if (item?.id.contains('treatmentid')) {
      await launch('${apis.apiPublic}/${item.id}');
    } else if (fileUrl.contains('pdf')) {
      PDFDocument.fromURL(fileUrl).then((value) {
        setState(() {
          isPdf = true;
          document = value;
          openDialog(item);
        });
      });
    } else {
      setState(() {
        isPdf = false;
        imageUrl = fileUrl;
        openDialog(item);
      });
    }
  }

  Widget onOpenImage(BuildContext context, String? fileName) {
    String? _fileName = fileName ?? null;
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 0,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 0,
      ),
      content: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: double.infinity,
            child: Column(children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.close),
                    ),
                  ],
                ),
                height: 40,
                padding: EdgeInsets.only(right: 10, left: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
              if (isPdf)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.84,
                  width: double.infinity,
                  child: PDFViewer(
                    document: document!,
                  ),
                ),
              if (!isPdf && imageUrl != null)
                Flexible(child: Image.network(imageUrl!))
            ]),
          );
        },
      ),
    );
  }

  openDialog(SearchMenu? file) {
    showDialog(
      context: context,
      builder: (context) => onOpenImage(context, file?.displayName),
    ).then((value) {});
  }

  bool isFocusedSearch = false;
  var filteredRouters = [];
  var _searchText = null;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Timer? _debounce;
  Widget buildCustomizedMenuItemButtons(BuildContext context) {
    return GridView.builder(
      key: _refreshKey,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 15,
      ),
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: _menuItems.length,
      itemBuilder: (context, index) {
        final menuItem = _menuItems[index];
        return GestureDetector(
          child: CustomSubTotal(
            key: UniqueKey(), // UniqueKey for CustomSubTotal
            menuItem.icon,
            menuItem.displayName!,
            null,
            null,
            10,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(menuItem.routerName!);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController tec = TextEditingController();
    return Scaffold(
      appBar: isFocusedSearch == false
          ? leadingWithoutBack('Dashboard', context)
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isFocusedSearch == false)
                        Text(
                          "Hallo ${title}!",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(244, 115, 123, 126),
                              fontWeight: FontWeight.bold),
                        ),
                      if (isFocusedSearch == false)
                        SizedBox(
                          height: 12,
                        ),
                      if (isFocusedSearch)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isFocusedSearch = false;
                            });
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.close),
                              Text('Schließen'),
                            ],
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.only(left: 0, right: 0),
                        child: Form(
                            key: _formkey,
                            child: TextFormField(
                              // controller: tec,
                              onTapOutside: (event) {
                                if (filteredRouters.length == 0) {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    isFocusedSearch = false;
                                  }); /**/
                                }
                              },
                              onChanged: (value) {
                                filteredRouters = [];
                                // ignore: unnecessary_null_comparison
                                print(value);
                                _searchText = value;
                                if (value != "" && value != null) {
                                  filteredRouters = [];
                                  filteredRouters = searchAllRoutes
                                      .where((element) => (element.displayName
                                              .toLowerCase()
                                              .contains(value.toLowerCase()) ||
                                          (element.keywords!
                                              .toLowerCase()
                                              .contains(value.toLowerCase()))))
                                      .toList();

                                  if (_debounce?.isActive ?? false)
                                    _debounce?.cancel();
                                  _debounce = Timer(
                                      const Duration(milliseconds: 500), () {
                                    onsearchfunction(value);
                                  });
                                } else {
                                  _debounce?.cancel();
                                  filteredRouters = [];
                                }

                                setState(() {});
                              },
                              onTap: () {
                                setState(() {
                                  //filteredRouters = searchAllRoutes;
                                  isFocusedSearch = true;
                                }); /**/
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor:
                                      const Color.fromARGB(255, 244, 246, 246),
                                  hintText: 'Suchen',
                                  hintStyle: TextStyle(
                                      fontSize: 16.0,
                                      color: Color.fromARGB(255, 69, 81, 84)),
                                  prefixIcon: Icon(Icons.search_sharp),
                                  suffixIcon: filteredRouters.length > 0
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              child: Icon(Icons.close_outlined),
                                              onTap: () {
                                                setState(() {
                                                  filteredRouters = [];
                                                  _formkey.currentState
                                                      ?.reset();
                                                });
                                              },
                                            )
                                          ],
                                        )
                                      : null),
                            )),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              if (isFocusedSearch == false)
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Builder(
                              key: _refreshKey,
                              builder: (BuildContext context) {
                                // This Builder will rebuild the UI when _menuItems change
                                return buildCustomizedMenuItemButtons(context);
                                /**/
                              })
                        ],
                      ),
                    ],
                  ),
                ),
              if (isFocusedSearch == true)
                for (var item in filteredRouters)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: GestureDetector(
                      onTap: () async {
                        onClickSearchFunctionResult(item);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (item.type == 'folder')
                            Icon(
                              Icons.folder,
                              color: iconColor,
                              size: 40,
                            ),
                          if (item.type == 'file')
                            Icon(
                              Icons.file_copy,
                              color: iconColor,
                              size: 40,
                            ),
                          if (item.icon != null && item.icon is IconData)
                            Icon(
                              item.icon,
                              color: iconColor,
                              size: 40,
                            ),
                          if (item.icon != null && item.icon is Widget)
                            Container(
                              child: item.icon,
                              width: 40,
                              height: 40,
                            ),
                          SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(
                              item.displayName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: _selectedIndex),
    );
  }
}
