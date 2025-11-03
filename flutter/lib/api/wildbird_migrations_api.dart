import 'package:intl/intl.dart';
import 'package:livetec_flutter_app/api/fetch_api.dart';
import 'package:livetec_flutter_app/types/migration.dart';
import 'package:livetec_flutter_app/utils/string.dart';

Future<List<Migration>> getWildbirdMigrations(
  DateTime from,
  DateTime to,
  String? species,
) async {
  final data = await dioService.fetch(
    FetchMethod.get,
    '/api/wildbird-migrations',
    query: {
      'from': DateFormat('yyyy-MM-dd').format(from),
      'to': DateFormat('yyyy-MM-dd').format(to),
      if (species != null) 'species': capitalizeFirstLetter(species),
    },
  );

  if (data == null) return [];
  return (data as List).map((element) => Migration.fromJson(element)).toList();
}
