import 'package:flutter/foundation.dart';
import 'package:leado/model/email_data_response.dart';
import 'package:leado/utils/api_client.dart';
import 'package:leado/utils/shared_pref.dart';

class EmailDataRepository {
  static Future<EmailDataResponse?> sendEmailData() async {
    try {
      final exhibitorId = await SharedPref.getExhibitorId();
      debugPrint("Exibitor Id : $exhibitorId");
      final response = await ApiClient.get(
        '/LeadVault/webapi/emaildataAPI.ashx?id=$exhibitorId',
      );

      final decoded = ApiClient.handleResponse(response);

      return EmailDataResponse.fromJson(decoded);
    } catch (e) {
      debugPrint("Email Data Error : $e");
      return null;
    }
  }
}