import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:leado/repository/qr_sync_repository.dart';

class ConnectivityService {
  static StreamSubscription<List<ConnectivityResult>>? _subscription;

  static void startListening() {
     _subscription = Connectivity().onConnectivityChanged.listen((results) async {

    debugPrint("Connectivity Changed: $results");

    if (!results.contains(ConnectivityResult.none)) {
      debugPrint("Internet Available");

      await Future.delayed(const Duration(seconds: 2));

      await QrSyncRepository.syncPendingQr();
    }
  });
  }

  static void dispose() {
    _subscription?.cancel();
  }
}