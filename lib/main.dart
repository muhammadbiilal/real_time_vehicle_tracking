import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:real_time_vehicle_tracking/GpsGateService.dart';
import 'package:real_time_vehicle_tracking/data_models.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real Time Vehicle Tracking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FleetTrackingScreen(), // Your main screen
    );
  }
}

class FleetTrackingScreen extends StatefulWidget {
  @override
  _FleetTrackingScreenState createState() => _FleetTrackingScreenState();
}

class _FleetTrackingScreenState extends State<FleetTrackingScreen> {
  final GpsGateService gpsGateService = GpsGateService();
  List<Device> _devices = [];
  List<Geofence> _geofences = [];
  VehicleLocation? _vehicleLocation;
  TelematicsData? _telematicsData;
  List<TrackInfo>? _trackInfos;
  GoogleMapController? _mapController;
  String _selectedVehicleId = '';

  @override
  void initState() {
    super.initState();
    _fetchDevicesForUser('user_id_here'); // Replace with your actual user ID
    _fetchGeofences();
  }

  // Fetch the list of devices (vehicles) for the user
  Future<void> _fetchDevicesForUser(String userId) async {
    try {
      List<Device> devices = await gpsGateService.getDevicesForUser(userId);
      setState(() {
        _devices = devices;
      });
    } catch (error) {
      print("Error fetching devices: $error");
    }
  }

  // Fetch geofences
  Future<void> _fetchGeofences() async {
    try {
      List<Geofence> geofences = await gpsGateService.getGeofences();
      setState(() {
        _geofences = geofences;
      });
    } catch (error) {
      print("Error fetching geofences: $error");
    }
  }

  // Fetch vehicle data when a vehicle is selected
  Future<void> _fetchVehicleData(String vehicleId) async {
    try {
      VehicleLocation vehicleLocation =
          await gpsGateService.getVehicleLocation(vehicleId);
      TelematicsData telematicsData =
          await gpsGateService.getTelematicsData(vehicleId);
      List<TrackInfo> trackInfos =
          await gpsGateService.getVehicleTrackInfo(vehicleId);

      setState(() {
        _vehicleLocation = vehicleLocation;
        _telematicsData = telematicsData;
        _trackInfos = trackInfos;
      });

      _mapController?.animateCamera(CameraUpdate.newLatLng(
        LatLng(vehicleLocation.latitude, vehicleLocation.longitude),
      ));
    } catch (error) {
      print("Error fetching vehicle data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fleet Tracking'),
      ),
      body: Column(
        children: [
          _buildDeviceDropdown(), // Dropdown to select the vehicle
          _buildGeofenceList(), // Display geofences
          _vehicleLocation == null
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_vehicleLocation?.latitude ?? 0,
                          _vehicleLocation?.longitude ?? 0),
                      zoom: 12,
                    ),
                  ),
                ),
          if (_telematicsData != null) _buildTelematicsInfo(),
          if (_trackInfos != null) _buildTrackInfo(),
        ],
      ),
    );
  }

  // Dropdown for selecting vehicles
  Widget _buildDeviceDropdown() {
    return DropdownButton<String>(
      hint: Text('Select Vehicle'),
      value: _selectedVehicleId.isNotEmpty ? _selectedVehicleId : null,
      items: _devices.map((device) {
        return DropdownMenuItem<String>(
          value: device.id,
          child: Text(device.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedVehicleId = value!;
        });
        _fetchVehicleData(value!); // Fetch data for the selected vehicle
      },
    );
  }

  // Widget to display telematics info (e.g., fuel, speed)
  Widget _buildTelematicsInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
              'Fuel Consumption: ${_telematicsData?.fuelConsumption ?? 'N/A'} L'),
          Text('Speed: ${_telematicsData?.speed ?? 'N/A'} km/h'),
        ],
      ),
    );
  }

  // Widget to display track info
  Widget _buildTrackInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: _trackInfos?.map((track) {
              return Text(
                  'Distance: ${track.totalDistance} m, Start: ${track.startTime}, End: ${track.endTime}');
            }).toList() ??
            [Text('No track data available')],
      ),
    );
  }

  // Widget to display geofences
  Widget _buildGeofenceList() {
    return Column(
      children: _geofences.map((geofence) {
        return Text('Geofence: ${geofence.name}');
      }).toList(),
    );
  }
}
