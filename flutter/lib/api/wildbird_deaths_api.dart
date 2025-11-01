import 'package:intl/intl.dart';
import 'package:livetec_flutter_app/api/fetch_api.dart';

Future<void> getWildbirdDeaths(DateTime from, DateTime to) async {
  fetchApi(
    FetchMethod.get,
    '/api/wildbird-deaths',
    query: {
      'from': DateFormat('yyyy-MM-dd').format(from),
      'to': DateFormat('yyyy-MM-dd').format(to),
    },
  );
}