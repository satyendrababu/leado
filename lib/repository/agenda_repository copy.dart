import 'package:flutter/material.dart';
import 'package:leado/model/agenda_model.dart';
import 'package:leado/model/show_info_model.dart';
import 'package:leado/utils/api_client.dart';
import 'package:leado/utils/shared_pref.dart';

class AgendaRepository {

  static Future<AgendaModel?> getAgenda() async {
    try {
      final response = await ApiClient.get(
        '/LeadVault/webapi/AgendaAPI.ashx',
      );

      final decoded = ApiClient.handleResponse(response);

      final model = AgendaModel.fromJson(decoded);

      await SharedPref.saveAgenda(model);

      return model;
    } catch (e) {
      debugPrint("Agenda Error : $e");
      return null;
    }
  }
}