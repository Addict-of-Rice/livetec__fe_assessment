import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

//TODO: move baseUrl to .env
const baseUrl = 'http://10.0.2.2:3000';

enum FetchMethod { get, post, put, delete, patch }

Future<dynamic> fetchApi(
  FetchMethod method,
  String path, {
  Map<String, dynamic>? query,
  Map<String, dynamic>? body,
}) async {
  try {
    Uri uri = Uri.parse(
      '$baseUrl$path',
    ).replace(queryParameters: query?.map((k, v) => MapEntry(k, v.toString())));

    final headers = {'Content-Type': 'application/json'};
    http.Response response;

    switch (method) {
      case FetchMethod.get:
        response = await http.get(uri);
        break;
      case FetchMethod.post:
        response = await http.post(
          uri,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
        break;
      case FetchMethod.put:
        response = await http.put(
          uri,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
        break;
      case FetchMethod.patch:
        response = await http.patch(
          uri,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
        break;
      case FetchMethod.delete:
        response = await http.delete(uri);
        break;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  } catch (error) {
    if (kDebugMode) {
      print('Request failed: $error');
    }
    return null;
  }
}
