import 'package:flutter/material.dart';
import 'package:leado/model/qr_response.dart';

import '../utils/api_client.dart';

class QrRepository {
  static Future<QrResponse?> sendQr(Map<String, dynamic> qrValue) async {
    try {
      final response = await ApiClient.post(
        '/LeadVault/qrapi',
        body: qrValue,
        // token: 'YOUR_AUTH_TOKEN',
      );
      debugPrint('Respose: $response');
      final decoded = ApiClient.handleResponse(response);
      return QrResponse.fromJson(decoded);
    } catch (e) {
      debugPrint('QR API error: $e');
      return null;
    }
  }
}
