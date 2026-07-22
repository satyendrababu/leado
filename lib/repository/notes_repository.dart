import 'package:flutter/material.dart';
import 'package:leado/model/note_response.dart';
import 'package:leado/utils/api_client.dart';

class NotesRepository {
  static Future<NoteResponse?> addNotes({
    required String qrCodeId,
    required String notes,
    required int rating,
    required String exhibitorId,
  }) async {
    try {
      final response = await ApiClient.post(
        '/LeadVault/webapi/AddNodesAPI.ashx',
        body: {
          "qrcodeid": qrCodeId,
          "Notes": notes,
          "Rating": rating.toString(),
          "exhibitorid": exhibitorId,
        },
      );

      final decoded = ApiClient.handleResponse(response);

      return NoteResponse.fromJson(decoded);
    } catch (e) {
      debugPrint("Add Notes Error : $e");
      return null;
    }
  }
}