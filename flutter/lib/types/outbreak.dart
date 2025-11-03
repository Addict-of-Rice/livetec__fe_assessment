import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:livetec_flutter_app/types/risk.dart';
import 'package:livetec_flutter_app/utils/date_time.dart';
import 'package:livetec_flutter_app/utils/parse_lat_lng.dart';

class Outbreak {
  final String id;
  final String confNumber;
  final String title;
  final Risk risk;
  final LatLng location;
  final String type;
  final String disease;
  final String zone;
  final int zoneDiameter;
  final List<List<LatLng>> zoneShape;
  final DateTime started;
  final DateTime? ended;

  Outbreak(
    this.id,
    this.confNumber,
    this.title,
    this.risk,
    this.location,
    this.type,
    this.disease,
    this.zone,
    this.zoneDiameter,
    this.zoneShape,
    this.started,
    this.ended,
  );

  factory Outbreak.fromJson(Map<String, dynamic> json) {
    return Outbreak(
      json['id'] as String,
      json['confNumber'] as String,
      json['title'] as String,
      Risk.values.firstWhere(
        (value) =>
            value.name.toLowerCase() == (json['risk'] as String).toLowerCase(),
        orElse: () => Risk.low,
      ),
      parseLatLngFromLocation(json['location']),
      json['type'] as String,
      json['disease'] as String,
      json['zone'] as String,
      json['zoneDiameter'] as int,
      parseLatLngFromZoneShapes(json['zoneShape']),
      stripTime(DateTime.parse(json['started'])),
      json['ended'] != null ? stripTime(DateTime.parse(json['ended'])) : null,
    );
  }
}
