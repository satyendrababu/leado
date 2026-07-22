import 'package:flutter/material.dart';
import 'package:leado/model/show_info_model.dart';
import 'package:leado/utils/api_client.dart';
import 'package:leado/utils/shared_pref.dart';

class ShowInfoRepository {

  static Future<ShowInfoModel?> getShowInfo() async {
    try {
      final response = await ApiClient.get(
        '/LeadVault/webapi/ShowinfoAPI.ashx',
      );

      final decoded = ApiClient.handleResponse(response);

      final model = ShowInfoModel.fromJson(decoded);

      await SharedPref.saveShowInfo(model);

      return model;
    } catch (e) {
      debugPrint("Show Info Error : $e");
      return null;
    }
  }
}