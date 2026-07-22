import 'package:flutter/material.dart';
import 'package:leado/utils/shared_pref.dart';

class ScanCountProvider extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  Future<void> loadCount() async {
    _count = (await SharedPref.getScannedQrList()).length;
    notifyListeners();
  }
}