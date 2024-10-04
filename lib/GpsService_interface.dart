import 'package:real_time_vehicle_tracking/data_models.dart';

abstract class GpsService {
  Future<VehicleLocation> getVehicleLocation(String vehicleId);
  Future<List<Route>> getRoutesForVehicle(String vehicleId);
  Future<TelematicsData> getTelematicsData(String vehicleId);
}
