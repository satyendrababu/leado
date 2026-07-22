import 'package:flutter/foundation.dart';
import 'package:leado/utils/api_client.dart';
import '../model/exhibitor_response.dart';
import '../utils/shared_pref.dart';

class ExhibitorRepository {
  static Future<ExhibitorResponse?> getExhibitorList() async {
    try {
      final response = await ApiClient.get(
        '/LeadVault/webapi/ExhibitorlistAPI.ashx',
      );

      debugPrint('Exhibitor Response: $response');

      final decoded = ApiClient.handleResponse(response);

      final exhibitorResponse = ExhibitorResponse.fromJson(decoded);

      await SharedPref.saveExhibitors(
        exhibitorResponse.exhibitors,
      );

      return exhibitorResponse;
    } catch (e) {
      debugPrint('Exhibitor API Error: $e');
      return null;
    }
  }
}