import 'package:flutter/foundation.dart';

import '../model/login_page_model.dart';
import '../utils/shared_pref.dart';
import '../utils/api_client.dart';

class LoginRepository {
  static Future<LoginPageModel?> getLoginPage() async {
    try {
      final response = await ApiClient.get(
        '/LeadVault/webapi/LoginpageAPI.ashx',
      );

      debugPrint('Login Response: $response');

      final decoded = ApiClient.handleResponse(response);

      final loginPage = LoginPageModel.fromJson(decoded);

      await SharedPref.saveShows(loginPage.shows);

      return loginPage;
    } catch (e) {
      debugPrint('Login API Error: $e');
      return null;
    }
  }
}