import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:livetec_flutter_app/utils/date_time.dart';
import 'package:livetec_flutter_app/utils/parse_lat_lng.dart';

class Death {
  final String id;
  final DateTime date;
  final String locality;
  final String country;
  final String? county;
  final String species;
  final String? virus;
  final int numberOfBirdsAffected;
  final LatLng location;

  Death(
    this.id,
    this.date,
    this.locality,
    this.country,
    this.county,
    this.species,
    this.virus,
    this.numberOfBirdsAffected,
    this.location,
  );

  factory Death.fromJson(Map<String, dynamic> json) {
    return Death(
      json['id'] as String,
      stripTime(DateTime.parse(json['date'])),
      json['locality'] as String,
      json['country'] as String,
      json['county'] as String?,
      json['species'] as String,
      json['virus'] as String?,
      json['numberOfBirdsAffected'] as int,
      parseLatLngFromLocation(json['location']),
    );
  }
}
