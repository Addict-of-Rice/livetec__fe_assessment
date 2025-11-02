import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

//TODO: move baseUrl to .env
const baseUrl = 'http://10.0.2.2:3000';

enum FetchMethod { get, post, put, patch, delete }

class DioService {
  final Dio _dio;

  DioService({required String baseUrl})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'Connection': 'Keep-Alive',
            'Accept-Encoding': 'gzip, deflate, br',
          },
          connectTimeout: Duration(seconds: 10),
          receiveTimeout: Duration(seconds: 10),
        ),
      ) {
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
        ),
      );
    }
  }

  Future<dynamic> fetch(
    FetchMethod method,
    String path, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? body,
  }) async {
    try {
      Response response;

      switch (method) {
        case FetchMethod.get:
          response = await _dio.get(path, queryParameters: query);
          break;
        case FetchMethod.post:
          response = await _dio.post(path, queryParameters: query, data: body);
          break;
        case FetchMethod.put:
          response = await _dio.put(path, queryParameters: query, data: body);
          break;
        case FetchMethod.patch:
          response = await _dio.patch(path, queryParameters: query, data: body);
          break;
        case FetchMethod.delete:
          response = await _dio.delete(
            path,
            queryParameters: query,
            data: body,
          );
          break;
      }

      if (response.data is Map || response.data is List) {
        return response.data;
      }

      return jsonDecode(response.data.toString());
    } on DioException catch (error) {
      if (kDebugMode) {
        print('Request failed: ${error.response?.statusCode} ${error.message}');
        if (error.response != null) {
          print('Response: ${error.response?.data}');
        }
      }
      return null;
    } catch (error) {
      if (kDebugMode) {
        print('Unexpected error: $error');
      }
      return null;
    }
  }
}

final dioService = DioService(baseUrl: baseUrl);
