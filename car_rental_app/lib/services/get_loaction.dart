import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GetLocationServices {
  Future<String> getCityNameFromCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check and request permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Get placemark
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    String cityName = placemarks[0].locality ?? "Unknown";
    return cityName;
  }
}
