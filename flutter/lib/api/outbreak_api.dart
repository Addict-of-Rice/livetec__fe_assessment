import 'package:intl/intl.dart';
import 'package:livetec_flutter_app/api/fetch_api.dart';
import 'package:livetec_flutter_app/types/outbreak.dart';
import 'package:livetec_flutter_app/types/risk.dart';
import 'package:livetec_flutter_app/utils/string.dart';

Future<List<Outbreak>> _fetchOutbreaks(
  String endpoint,
  DateTime from,
  DateTime to,
  Risk? risk,
  String? zone,
) async {
  final data = await dioService.fetch(
    FetchMethod.get,
    endpoint,
    query: {
      'from': DateFormat('yyyy-MM-dd').format(from),
      'to': DateFormat('yyyy-MM-dd').format(to),
      if (risk != null) 'risk': risk.name,
      if (zone != null) 'zone': capitalizeFirstLetter(zone),
    },
  );

  if (data == null) return [];
  return (data as List).map((element) => Outbreak.fromJson(element)).toList();
}

Future<List<Outbreak>> getActiveOutbreaks(
  DateTime from,
  DateTime to,
  Risk? risk,
  String? zone,
) => _fetchOutbreaks('/api/active-outbreaks', from, to, risk, zone);

Future<List<Outbreak>> getHistoricalOutbreaks(
  DateTime from,
  DateTime to,
  Risk? risk,
  String? zone,
) => _fetchOutbreaks('/api/historical-outbreaks', from, to, risk, zone);
