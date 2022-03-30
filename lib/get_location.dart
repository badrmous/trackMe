import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

getLocation() async {
  print("getting location");
  LocationPermission permission;
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location Not Available');
    }
  }
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  var addresses = await GeocodingPlatform.instance
      .placemarkFromCoordinates(position.latitude, position.longitude);
  var first = addresses.first;
  return [first, position.latitude, position.longitude];
}
