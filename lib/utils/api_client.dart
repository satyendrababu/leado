import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_constants.dart';

class ApiClient {
  /// Common headers
  static Map<String, String> _headers({String? token}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// -------------------- GET --------------------
  static Future<http.Response> get(
      String endpoint, {
        Map<String, String>? queryParams,
        String? token,
      }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}$endpoint',
    ).replace(queryParameters: queryParams);

    debugPrint('GET → $uri');

    return await http
        .get(uri, headers: _headers(token: token))
        .timeout(ApiConstants.timeout);
  }

  /// -------------------- POST --------------------
  static Future<http.Response> post(
      String endpoint, {
        required Map<String, dynamic> body,
        String? token,
      }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

    debugPrint('POST → $uri');
    debugPrint('BODY → $body');

    return await http
        .post(
      uri,
      headers: _headers(token: token),
      body: jsonEncode(body),
    )
        .timeout(ApiConstants.timeout);
  }

  /// -------------------- PUT --------------------
  static Future<http.Response> put(
      String endpoint, {
        required Map<String, dynamic> body,
        String? token,
      }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

    return await http
        .put(
      uri,
      headers: _headers(token: token),
      body: jsonEncode(body),
    )
        .timeout(ApiConstants.timeout);
  }

  /// -------------------- DELETE --------------------
  static Future<http.Response> delete(
      String endpoint, {
        String? token,
      }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

    return await http
        .delete(uri, headers: _headers(token: token))
        .timeout(ApiConstants.timeout);
  }

  /// -------------------- RESPONSE HANDLER --------------------
  static dynamic handleResponse(http.Response response) {
    debugPrint('STATUS → ${response.statusCode}');
    debugPrint('RESPONSE → ${response.body}');

    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);

      case 400:
        throw Exception('Bad Request');

      case 401:
        throw Exception('Unauthorized');

      case 500:
        throw Exception('Server Error');

      default:
        throw Exception('Something went wrong');
    }
  }
}
