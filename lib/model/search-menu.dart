import 'package:flutter/widgets.dart';

class SearchMenu {
  final String? id;
  final String? route;
  final String displayName;
  final String type;
  final dynamic? icon;
  SearchMenu(
      {required this.displayName,
      this.route,
      required this.type,
      this.id,
      this.icon});

  factory SearchMenu.fromJson(Map<String, dynamic> json) {
    return SearchMenu(
      displayName: json['displayName'],
      type: json['type'],
      route: json['route'],
      id: json['id'],
    );
  }
}
