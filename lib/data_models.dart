import 'package:google_maps_flutter/google_maps_flutter.dart';

class VehicleLocation {
  final double latitude;
  final double longitude;

  VehicleLocation({required this.latitude, required this.longitude});

  factory VehicleLocation.fromJson(Map<String, dynamic> json) {
    return VehicleLocation(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

class Route {
  final String routeId;
  final List<LatLng> waypoints;

  Route({required this.routeId, required this.waypoints});
}

class TelematicsData {
  final double fuelConsumption;
  final double speed;

  TelematicsData({required this.fuelConsumption, required this.speed});

  factory TelematicsData.fromJson(Map<String, dynamic> json) {
    return TelematicsData(
      fuelConsumption: json['fuelConsumption'],
      speed: json['speed'],
    );
  }
}

class Device {
  final String id;
  final String name;

  Device({required this.id, required this.name});

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'].toString(),
      name: json['name'],
    );
  }
}

class Geofence {
  final String id;
  final String name;

  Geofence({required this.id, required this.name});

  factory Geofence.fromJson(Map<String, dynamic> json) {
    return Geofence(
      id: json['id'].toString(),
      name: json['name'],
    );
  }
}

class TrackInfo {
  final double totalDistance;
  final String startTime;
  final String endTime;

  TrackInfo(
      {required this.totalDistance,
      required this.startTime,
      required this.endTime});

  factory TrackInfo.fromJson(Map<String, dynamic> json) {
    return TrackInfo(
      totalDistance: json['totalDistance'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }
}
