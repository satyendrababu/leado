import 'package:flutter/material.dart';
import 'package:leado/model/welcome_popup_model.dart';
import 'package:leado/utils/api_client.dart';
import 'package:leado/utils/shared_pref.dart';

class WelcomePopupRepository {
  static Future<WelcomePopupModel?> getWelcomePopup() async {
    try {
      final response = await ApiClient.get(
        "/LeadVault/webapi/WelcomePopupAPI.ashx",
      );

      final decoded = ApiClient.handleResponse(response);

      final model = WelcomePopupModel.fromJson(decoded);

      await SharedPref.saveWelcomePopup(model);

      return model;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}