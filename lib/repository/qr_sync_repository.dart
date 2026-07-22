import 'package:flutter/foundation.dart';
import 'package:leado/model/qr_response.dart';
import 'package:leado/model/scanned_qr.dart';
import 'package:leado/repository/qr_repository.dart';
import 'package:leado/utils/shared_pref.dart';

class QrSyncRepository {
  static bool _isSyncing = false;

  static Future<QrResponse?> syncPendingQr() async {
    if (_isSyncing) return null;

    _isSyncing = true;

    QrResponse? lastResponse;

    try {
      final pendingList = await SharedPref.getPendingQr();

      if (pendingList.isEmpty) {
        debugPrint("No Pending QR");
        return null;
      }

      debugPrint("Pending QR Count : ${pendingList.length}");

      for (final qr in pendingList) {
        final result = await QrRepository.sendQr({
          "qrcodeid": qr.qrcodeid,
          "firstname": qr.firstname,
          "company": qr.company,
          "exhibitorid": qr.exhibitorid,
        });

        if (result != null &&
            result.status.toLowerCase() == "success") {

          await SharedPref.markAsSynced(qr.qrcodeid);

          debugPrint("${qr.qrcodeid} Synced");

          // Store the latest successful response
          lastResponse = result;
        }
      }

      return lastResponse;

    } catch (e) {
      debugPrint("Sync Error : $e");
      return null;
    } finally {
      _isSyncing = false;
    }
  }

  static Future<bool> syncSingleQr(ScannedQr qr) async {
  try {
    final result = await QrRepository.sendQr({
      "qrcodeid": qr.qrcodeid,
      "firstname": qr.firstname,
      "company": qr.company,
      "exhibitorid": qr.exhibitorid,
    });

    if (result != null &&
        result.status.toLowerCase() == "success") {
      await SharedPref.markAsSynced(qr.qrcodeid);
      return true;
    }

    return false;
  } catch (e) {
    debugPrint("Single Sync Error : $e");
    return false;
  }
}
}