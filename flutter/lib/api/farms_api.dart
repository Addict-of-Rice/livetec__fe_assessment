import 'package:livetec_flutter_app/api/fetch_api.dart';
import 'package:livetec_flutter_app/types/classification.dart';
import 'package:livetec_flutter_app/types/farm.dart';
import 'package:livetec_flutter_app/utils/string.dart';

Future<List<Farm>> getFarms(
  String? country,
  String? county,
  Classification? classification,
  bool? operating,
) async {
  final data = await dioService.fetch(
    FetchMethod.get,
    '/api/farms',
    query: {
      if (country != null) 'country': capitalizeFirstLetter(country),
      if (county != null) 'county': capitalizeFirstLetter(county),
      if (classification != null) 'classification': classification.value,
      if (operating != null) 'operating': operating,
    },
  );

  if (data == null) return [];
  return (data as List).map((element) => Farm.fromJson(element)).toList();
}
