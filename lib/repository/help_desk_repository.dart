import 'package:flutter/material.dart';
import 'package:leado/model/help_desk_model.dart';
import 'package:leado/utils/api_client.dart';
import 'package:leado/utils/shared_pref.dart';

class HelpDeskRepository {

  static Future<HelpDeskModel?> getHelpDesk() async {
    try {
      final response = await ApiClient.get(
        '/LeadVault/webapi/HelpDeskAPI.ashx',
      );

      final decoded = ApiClient.handleResponse(response);

      final model = HelpDeskModel.fromJson(decoded);

      await SharedPref.saveHelpDesk(model);

      return model;
    } catch (e) {
      debugPrint("HelpDesk Error : $e");
      return null;
    }
  }
}