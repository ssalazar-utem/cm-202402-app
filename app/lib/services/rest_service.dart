import 'dart:convert';

import 'package:cm/models/access.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestService {
  static final Dio _client = Dio();
  static final Logger _logger = Logger();

  static const String _mime = 'application/json';
  static const String _baseUrl = 'https://api.sebastian.cl/oirs-utem';

  static Future<List<Access>> access() async {
    List<Access> list = [];
    _client.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true));

    SharedPreferences instance = await SharedPreferences.getInstance();
    final String idToken = instance.getString('idToken') ?? '';
    if (idToken.isNotEmpty) {
      const String url = "$_baseUrl/v1/info/access";
      Map<String, String> headers = {'accept': _mime, 'Authorization': idToken};
      Response<String> response =
          await _client.get(url, options: Options(headers: headers));
      final int httpCode = response.statusCode ?? 400;
      if (httpCode >= 200 && httpCode < 300) {
        final String responseJson = response.data ?? '';
        list = List<Access>.from(
            json.decode(responseJson).map((x) => Access.fromJson(x)));
      }
    }
    return list;
  }
}
