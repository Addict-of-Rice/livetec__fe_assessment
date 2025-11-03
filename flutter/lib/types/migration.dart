import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:livetec_flutter_app/utils/date_time.dart';
import 'package:livetec_flutter_app/utils/parse_lat_lng.dart';

class Migration {
  final String id;
  final String species;
  final DateTime startDate;
  final DateTime endDate;
  final LatLng startLocation;
  final LatLng endLocation;

  Migration(
    this.id,
    this.species,
    this.startDate,
    this.endDate,
    this.startLocation,
    this.endLocation,
  );

  factory Migration.fromJson(Map<String, dynamic> json) {
    return Migration(
      json['id'] as String,
      json['species'] as String,
      stripTime(DateTime.parse(json['startDate'])),
      stripTime(DateTime.parse(json['endDate'])),
      parseLatLngFromLocation(json['startLocation']),
      parseLatLngFromLocation(json['endLocation']),
    );
  }
}
