import 'dart:convert';

import 'package:earthquake/utils/helper_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:earthquake/models/earthquake_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class AppDataProvider with ChangeNotifier {
  final baseUrl = Uri.parse('https://earthquake.usgs.gov/fdsnws/event/1/query');
  Map<String, dynamic> queryParams = {};
  double _maxRadiusKm = 500;
  double _latitude = 0.0, _longitude = 0.0;

  String _startTime = '', _endTime = '';
  String _orderBy = 'time';
  String? _currentCity;
  final double _maxRadiusKmThreshold = 20001.6;
  bool _shouldUseLocation = false;
  EarthquakeModel? earthquakeModel;

  double get maxRadiusKm => _maxRadiusKm;

  double get latitude => _latitude;

  get longitude => _longitude;

  String get startTime => _startTime;

  get endTime => _endTime;

  String get orderBy => _orderBy;

  String? get currentCity => _currentCity;

  double get maxRadiusKmThreshold => _maxRadiusKmThreshold;

  bool get shouldUseLocation => _shouldUseLocation;

  bool get hasDataloaded => earthquakeModel!=null;

  void setOrder(String value){
    _orderBy = value;
    notifyListeners();
    _setQueryParams();
    getEarthquakeData();
  }
  _setQueryParams(){
    queryParams ['format'] = 'geojson';
    queryParams ['starttime'] = _startTime;
    queryParams ['endtime'] = _endTime;
    queryParams ['minmagnitude'] = '4';
    queryParams ['orderby'] = _orderBy;
    queryParams ['limit'] = '500';
    queryParams ['latitude'] = '$_latitude';
    queryParams ['longitude'] = '$_longitude';
    queryParams ['maxradiuskm'] = '$_maxRadiusKm';

  }

  init(){
    _startTime = getFormattedDateTime(DateTime.now().subtract(const Duration(days:1)).millisecondsSinceEpoch);
    _endTime = getFormattedDateTime(DateTime.now().millisecondsSinceEpoch);
    _maxRadiusKm = maxRadiusKmThreshold;
    _setQueryParams();
    getEarthquakeData();
  }


  Color getAlertColor(String color){
    return switch(color){
      'green' => Colors.green,
      'yellow' => Colors.yellow,
      'orange' => Colors.orange,
      _ => Colors.red,

    };
  }
  Future<void> getEarthquakeData() async {
    final uri = Uri.https(baseUrl.authority, baseUrl.path, queryParams);
    try {
      final response = await http.get(uri);
     if(response.statusCode == 200) {
       final json = jsonDecode(response.body) ;
       earthquakeModel = EarthquakeModel.fromJson(json);
       print(earthquakeModel!.features!.length);
       notifyListeners();
     }

    } catch(error){
      print(error.toString());
    }
  }
}


//136 5.00































