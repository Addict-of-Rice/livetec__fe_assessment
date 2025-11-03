import 'package:livetec_flutter_app/types/classification.dart';

class Farm {
  final int id;
  final double? latitude;
  final double? longitude;
  final String? county;
  final String? country;
  final List<Classification> classification;
  final bool operating;

  Farm(
    this.id,
    this.latitude,
    this.longitude,
    this.county,
    this.country,
    this.classification,
    this.operating,
  );

  factory Farm.fromJson(Map<String, dynamic> json) {
    final classificationJson = json['classification'];
    List<String> classificationStrings;

    if (classificationJson is String) {
      classificationStrings = [classificationJson];
    } else if (classificationJson is List) {
      classificationStrings = classificationJson.cast<String>();
    } else {
      classificationStrings = [];
    }

final classificationList = classificationStrings
    .map((string) => Classification.values.where((character) => character.value == string))
    .expand((element) => element)
    .toList();

    return Farm(
      json['id'] as int,
      json['latitude'] as double?,
      json['longitude'] as double?,
      json['county'] as String?,
      json['country'] as String?,
      classificationList,
      json['operating'] as bool,
    );
  }
}
