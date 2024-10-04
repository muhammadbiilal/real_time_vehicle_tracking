import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:real_time_vehicle_tracking/GpsService_interface.dart';
import 'package:real_time_vehicle_tracking/data_models.dart';

class GpsGateService implements GpsService {
  final String _baseUrl = 'https://zaxiss.gpsgate.com/api';
  final String _apiToken = 'v2:MDAwMDAwMDAwOTplYTYxMDhmZGQwMTBhMmZmM2EzYg==';
  final int _applicationId = 5; // Your application ID

  Map<String, String> _getHeaders() {
    return {
      'Authorization': 'Bearer $_apiToken',
      'Content-Type': 'application/json'
    };
  }

  @override
  Future<VehicleLocation> getVehicleLocation(String vehicleId) async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/applications/$_applicationId/users/$vehicleId/tracks'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return VehicleLocation.fromJson(data);
    } else {
      throw Exception('Failed to load vehicle location');
    }
  }

  @override
  Future<List<Route>> getRoutesForVehicle(String vehicleId) async {
    // Placeholder for route planning using Google Maps API
    return [];
  }

  @override
  Future<TelematicsData> getTelematicsData(String vehicleId) async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/applications/$_applicationId/accumulators/$vehicleId'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return TelematicsData.fromJson(data);
    } else {
      throw Exception('Failed to load telematics data');
    }
  }

  // Fetch devices (vehicles) for a specific user
  Future<List<Device>> getDevicesForUser(String userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/applications/$_applicationId/users/$userId/devices'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((device) => Device.fromJson(device)).toList();
    } else {
      throw Exception('Failed to load devices');
    }
  }

  // Fetch geofences
  Future<List<Geofence>> getGeofences() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/applications/$_applicationId/geofences'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((geofence) => Geofence.fromJson(geofence)).toList();
    } else {
      throw Exception('Failed to load geofences');
    }
  }

  // Fetch detailed track information (trackinfos)
  Future<List<TrackInfo>> getVehicleTrackInfo(String vehicleId) async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/applications/$_applicationId/users/$vehicleId/trackinfos'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((trackInfo) => TrackInfo.fromJson(trackInfo)).toList();
    } else {
      throw Exception('Failed to load track info');
    }
  }
}
