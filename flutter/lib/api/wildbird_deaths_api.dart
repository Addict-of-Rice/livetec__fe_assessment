import 'package:intl/intl.dart';
import 'package:livetec_flutter_app/api/fetch_api.dart';
import 'package:livetec_flutter_app/types/death.dart';

Future<List<Death>> getWildbirdDeaths(DateTime from, DateTime to) async {
  final data = await fetchApi(
    FetchMethod.get,
    '/api/wildbird-deaths',
    query: {
      'from': DateFormat('yyyy-MM-dd').format(from),
      'to': DateFormat('yyyy-MM-dd').format(to),
    },
  );

  if (data == null) return [];
  return (data as List).map((element) => Death.fromJson(element)).toList();
}
