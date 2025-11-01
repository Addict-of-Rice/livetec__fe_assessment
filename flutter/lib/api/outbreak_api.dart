import 'package:intl/intl.dart';
import 'package:livetec_flutter_app/api/fetch_api.dart';
import 'package:livetec_flutter_app/types/outbreak.dart';
import 'package:livetec_flutter_app/types/risk.dart';

Future<List<Outbreak>> _fetchOutbreaks(
  String endpoint,
  DateTime from,
  DateTime to,
  Risk? risk,
) async {
  final data = await fetchApi(
    FetchMethod.get,
    endpoint,
    query: {
      'from': DateFormat('yyyy-MM-dd').format(from),
      'to': DateFormat('yyyy-MM-dd').format(to),
      if (risk != null) 'risk': risk.name,
    },
  );

  if (data == null) return [];
  return (data as List).map((e) => Outbreak.fromJson(e)).toList();
}

Future<List<Outbreak>> getActiveOutbreaks(
  DateTime from,
  DateTime to,
  Risk? risk,
) => _fetchOutbreaks('/api/active-outbreaks', from, to, risk);

Future<List<Outbreak>> getHistoricalOutbreaks(
  DateTime from,
  DateTime to,
  Risk? risk,
) => _fetchOutbreaks('/api/historical-outbreaks', from, to, risk);
