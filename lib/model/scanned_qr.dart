import 'dart:convert';

class ScannedQr {
  final String qrcodeid;
  final String firstname;
  final String company;
  final String exhibitorid;
  bool isSynced;

  ScannedQr({
    required this.qrcodeid,
    required this.firstname,
    required this.company,
    required this.exhibitorid,
    this.isSynced = false,
  });

  factory ScannedQr.fromJson(Map<String, dynamic> json) {
    return ScannedQr(
      qrcodeid: json["qrcodeid"] ?? "",
      firstname: json["firstname"] ?? "",
      company: json["company"] ?? "",
      exhibitorid: json["exhibitorid"] ?? "",
      isSynced: json["isSynced"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "qrcodeid": qrcodeid,
      "firstname": firstname,
      "company": company,
      "exhibitorid": exhibitorid,
      "isSynced": isSynced,
    };
  }

  static String encode(List<ScannedQr> list) =>
      jsonEncode(list.map((e) => e.toJson()).toList());

  static List<ScannedQr> decode(String value) {
    final List<dynamic> json = jsonDecode(value);

    return json
        .map((e) => ScannedQr.fromJson(e))
        .toList();
  }
}