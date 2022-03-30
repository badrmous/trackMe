import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/get_location.dart';

class LocationNotifier extends ChangeNotifier {
  bool _startGettinLocation = false;
  String _lat = "";
  String _long = "";
  String _address = "";
  DateTime _date = DateTime.now();
  LatLng _lastMapPosition = const LatLng(45.521563, -122.677433);

  LatLng get lastMapPosition => _lastMapPosition;
  set lastMapPosition(LatLng value) {
    _lastMapPosition = value;
    notifyListeners();
  }

  bool get startGettingLocation => _startGettinLocation;
  set startGettingLocation(bool value) {
    _startGettinLocation = value;
    notifyListeners();
  }

  String get lat => _lat;
  set lat(String value) {
    _lat = value;
    notifyListeners();
  }

  String get long => _long;
  set long(String value) {
    _long = value;
    notifyListeners();
  }

  String get address => _address;
  set address(String value) {
    _address = value;
    notifyListeners();
  }

  DateTime get date => _date;
  set date(DateTime value) {
    _date = value;
    notifyListeners();
  }

  getLocationLoop() async {
    List data = await getLocation();
    lat = data[1].toString();
    long = data[2].toString();
    date = DateTime.now();
    lastMapPosition = LatLng(data[1], data[2]);
    address = "${data[0].administrativeArea} : ${data[0].locality} ";
    print("${data[0].administrativeArea} : ${data[0].locality}");
    print('latitude: ${data[1]} / longitude: ${data[2]}');
  }
}
