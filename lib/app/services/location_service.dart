import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../utils/utils.dart';

class LocationService {
  Location location = Location();

  Future<Map<String, double?>?> initializeAndGetLocaton(
      BuildContext context) async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    //first check if location is enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        Utils.showSnackBar("Please enable location service", context);
        return null;
      }
    }
    //if service is enabled ask permission for location from user
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        Utils.showSnackBar("Please allow location access", context);
        return null;
      }
    }

    //After permission granted,return coordinartes
    LocationData locData = await location.getLocation();
    return {
      'latitude': locData.latitude,
      'longitude': locData.longitude,
    };
  }
}
