import 'package:background_location/background_location.dart';
import 'package:hive/hive.dart';

part 'location_record.g.dart';

@HiveType(typeId: 0)
class LocationRecord extends HiveObject {
  @HiveField(0)
  double latitude;

  @HiveField(1)
  double longitude;

  @HiveField(2)
  double altitude;

  @HiveField(3)
  double bearing;

  @HiveField(4)
  double accuracy;

  @HiveField(5)
  double speed;

  @HiveField(6)
  double time;

  @HiveField(7)
  DateTime timestamp;

  LocationRecord({
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.bearing,
    required this.accuracy,
    required this.speed,
    required this.time,
    required this.timestamp,
  });

  LocationRecord.fromLocation({
    required Location location,
    required this.timestamp,
  })  : latitude = location.latitude ?? 0.0,
        longitude = location.longitude ?? 0.0,
        altitude = location.altitude ?? 0.0,
        bearing = location.bearing ?? 0.0,
        accuracy = location.accuracy ?? 0.0,
        speed = location.speed ?? 0.0,
        time = location.time ?? 0.0;
}
