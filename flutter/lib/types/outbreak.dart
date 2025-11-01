import 'package:livetec_flutter_app/types/location.dart';
import 'package:livetec_flutter_app/types/risk.dart';

class Outbreak {
  final String id;
  final String confNumber;
  final String title;
  final Risk risk;
  final Location location;
  final String type;
  final String disease;
  final String zone;
  final int zoneDiameter;
  final List<Location> zoneShape;
  final DateTime started;
  final DateTime ended;

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
        (r) => r.name.toLowerCase() == (json['risk'] as String).toLowerCase(),
        orElse: () => Risk.low,
      ),
      Location.fromJson(json['location']),
      json['type'] as String,
      json['disease'] as String,
      json['zone'] as String,
      json['zoneDiameter'] as int,
      (json['zoneShape'] as List)
          .map((e) => Location.fromJson(e))
          .toList(),
      DateTime.parse(json['started']),
      DateTime.parse(json['ended']),
    );
  }
}