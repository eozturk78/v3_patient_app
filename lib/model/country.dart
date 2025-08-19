import 'dart:convert';

class Country {
  final int countryId;
  final String countryName;
  final String? flag;
  final List<City> cities;

  Country(
      {required this.countryId,
      required this.countryName,
      this.flag,
      required this.cities});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
        countryId: json['countryId'],
        countryName: json['countryName'],
        flag: json['flag'],
        cities: (json['cities'] as List).map((e) => City.fromJson(e)).toList());
  }
}

class City {
  final int cityId;
  final String cityName;

  City({required this.cityId, required this.cityName});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(cityId: json['cityId'], cityName: json['cityName']);
  }
}
