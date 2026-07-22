import 'dart:convert';

import 'package:leado/model/agenda_model.dart';
import 'package:leado/model/exhibitor_response.dart';
import 'package:leado/model/help_desk_model.dart';
import 'package:leado/model/scanned_qr.dart';
import 'package:leado/model/show_info_model.dart';
import 'package:leado/model/welcome_popup_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/login_page_model.dart';

class SharedPref {
  static const String _showsKey = "shows";

  static Future<void> saveShows(List<ShowModel> shows) async {
    final pref = await SharedPreferences.getInstance();

    final jsonString = jsonEncode(
      shows.map((e) => e.toJson()).toList(),
    );

    await pref.setString(_showsKey, jsonString);
  }

  static Future<List<ShowModel>> getShows() async {
    final pref = await SharedPreferences.getInstance();
    final json = pref.getString(_showsKey);
    if (json == null) return [];
    final List data = jsonDecode(json);
    return data.map((e) => ShowModel.fromJson(e)).toList();
  }

  static const String _exhibitorKey = "exhibitors";

  static Future<void> saveExhibitors(
      List<ExhibitorModel> exhibitors) async {

    final pref = await SharedPreferences.getInstance();

    final json = jsonEncode(
      exhibitors.map((e) => e.toJson()).toList(),
    );

    await pref.setString(_exhibitorKey, json);
  }

  static Future<List<ExhibitorModel>> getExhibitors() async {

    final pref = await SharedPreferences.getInstance();

    final json = pref.getString(_exhibitorKey);

    if (json == null || json.isEmpty) {
      return [];
    }

    final List<dynamic> data = jsonDecode(json);

    return data
        .map((e) => ExhibitorModel.fromJson(e))
        .toList();
  }
  static const String _isLoggedIn = "isLoggedIn";
  static const String _selectedShow = "selectedShow";
  static const String _loggedInExhibitor = "loggedInExhibitor";

  static Future<void> saveLogin({
  required ShowModel show,
  required ExhibitorModel exhibitor,
}) async {
  final pref = await SharedPreferences.getInstance();

  await pref.setBool(_isLoggedIn, true);
  await pref.setString(_selectedShowCode, show.showCode);
  await pref.setString(_loginCode, exhibitor.loginCode);

  await pref.setString(
    _selectedShow,
    jsonEncode(show.toJson()),
  );

  await pref.setString(
    _loggedInExhibitor,
    jsonEncode(exhibitor.toJson()),
  );
}

static Future<bool> isUserLoggedIn() async {
  final pref = await SharedPreferences.getInstance();

  return pref.getBool(_isLoggedIn) ?? false;
}

static Future<ShowModel?> getSelectedShow() async {
  final pref = await SharedPreferences.getInstance();

  final json = pref.getString(_selectedShow);

  if (json == null) return null;

  return ShowModel.fromJson(jsonDecode(json));
}

static Future<ExhibitorModel?> getLoggedInExhibitor() async {
  final pref = await SharedPreferences.getInstance();

  final json = pref.getString(_loggedInExhibitor);

  if (json == null) return null;

  return ExhibitorModel.fromJson(jsonDecode(json));
}

static Future<void> logout() async {
  final pref = await SharedPreferences.getInstance();

  await pref.remove(_isLoggedIn);
  await pref.remove(_selectedShow);
  await pref.remove(_loggedInExhibitor);
}

static const String _scannedQr = "scanned_qr";
static Future<void> saveScannedQr(
    ScannedQr qr) async {

  final pref = await SharedPreferences.getInstance();

  final list = await getScannedQrList();

  list.add(qr);

  await pref.setString(
    _scannedQr,
    ScannedQr.encode(list),
  );
}

static Future<List<ScannedQr>> getScannedQrList()
async {

  final pref = await SharedPreferences.getInstance();

  final json = pref.getString(_scannedQr);

  if (json == null || json.isEmpty) {
    return [];
  }

  return ScannedQr.decode(json);
}

static Future<bool> isAlreadyScanned(
    String qrCodeId) async {

  final list = await getScannedQrList();

  return list.any(
        (e) => e.qrcodeid == qrCodeId,
  );
}

static Future<void> markAsSynced(
    String qrCodeId) async {

  final pref = await SharedPreferences.getInstance();

  final list = await getScannedQrList();

  for (final item in list) {
    if (item.qrcodeid == qrCodeId) {
      item.isSynced = true;
    }
  }

  await pref.setString(
    _scannedQr,
    ScannedQr.encode(list),
  );
}

static Future<List<ScannedQr>>
getPendingQr() async {

  final list = await getScannedQrList();

  return list
      .where((e) => !e.isSynced)
      .toList();
}

static Future<int> pendingQrCount() async {
  final list = await getPendingQr();
  return list.length;
}

static Future<void> clearScannedQr() async {
  final pref = await SharedPreferences.getInstance();

  await pref.remove(_scannedQr);
}

static Future<String?> getExhibitorId() async {
  final showCode = await SharedPref.getShowCode();
final loginCode = await SharedPref.getLoginCode();
  final exhibitors = await getExhibitors();

  try {
    final exhibitor = exhibitors.firstWhere(
      (e) =>
       e.loginCode == loginCode &&
          e.isActive,
    );

    return exhibitor.botExhibitorId.toString();
  } catch (e) {
    return null;
  }
}
static const String _selectedShowCode = "selected_show_code";
static const String _loginCode = "login_code";

static Future<String?> getShowCode() async {
  final pref = await SharedPreferences.getInstance();
  return pref.getString(_selectedShowCode);
}

static Future<String?> getLoginCode() async {
  final pref = await SharedPreferences.getInstance();
  return pref.getString(_loginCode);
}
static const _showInfo = "show_info";

static Future<void> saveShowInfo(
    ShowInfoModel model) async {

  final pref = await SharedPreferences.getInstance();

  await pref.setString(
    _showInfo,
    jsonEncode(model.toJson()),
  );
}

static Future<ShowInfoModel?> getShowInfo() async {

  final pref = await SharedPreferences.getInstance();

  final json = pref.getString(_showInfo);

  if (json == null) return null;

  return ShowInfoModel.fromJson(
      jsonDecode(json));
}

static const _agenda = "agenda";

static Future<void> saveAgenda(
    AgendaModel model) async {

  final pref = await SharedPreferences.getInstance();

  await pref.setString(
    _agenda,
    jsonEncode(model.toJson()),
  );
}

static Future<AgendaModel?> getAgenda() async {

  final pref = await SharedPreferences.getInstance();

  final json = pref.getString(_agenda);

  if (json == null) return null;

  return AgendaModel.fromJson(
      jsonDecode(json));
}
/////
static const _helpDesk = "help_desk";

static Future<void> saveHelpDesk(
    HelpDeskModel model) async {

  final pref = await SharedPreferences.getInstance();

  await pref.setString(
    _helpDesk,
    jsonEncode(model.toJson()),
  );
}

static Future<HelpDeskModel?> getHelpDesk() async {

  final pref = await SharedPreferences.getInstance();

  final json = pref.getString(_helpDesk);

  if (json == null) return null;

  return HelpDeskModel.fromJson(
      jsonDecode(json));
}

static const _welcomePopup = "welcome_popup";

static Future<void> saveWelcomePopup(
    WelcomePopupModel model) async {

  final pref = await SharedPreferences.getInstance();

  await pref.setString(
    _welcomePopup,
    jsonEncode(model.toJson()),
  );
}

static Future<WelcomePopupModel?> getWelcomePopup() async {

  final pref = await SharedPreferences.getInstance();

  final json = pref.getString(_welcomePopup);

  if (json == null) return null;

  return WelcomePopupModel.fromJson(
      jsonDecode(json));
}

static const String _welcomeShown = "welcome_shown";
static Future<void> saveWelcomeShown(bool value) async {
  final pref = await SharedPreferences.getInstance();
  await pref.setBool(_welcomeShown, value);
}

static Future<bool> isWelcomeShown() async {
  final pref = await SharedPreferences.getInstance();
  return pref.getBool(_welcomeShown) ?? false;
}

}