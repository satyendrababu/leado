class ExhibitorResponse {
  final String pageName;
  final List<ExhibitorModel> exhibitors;

  ExhibitorResponse({
    required this.pageName,
    required this.exhibitors,
  });

  factory ExhibitorResponse.fromJson(
      Map<String, dynamic> json) {
    return ExhibitorResponse(
      pageName: json["pageName"] ?? "",
      exhibitors: (json["exhibitors"] as List)
          .map((e) => ExhibitorModel.fromJson(e))
          .toList(),
    );
  }
}
class ExhibitorModel {
  final int botExhibitorId;
  final String companyName;
  final String name;
  final String showType;
  final bool isActive;
  final String loginCode;

  ExhibitorModel({
    required this.botExhibitorId,
    required this.companyName,
    required this.name,
    required this.showType,
    required this.isActive,
    required this.loginCode,
  });

  factory ExhibitorModel.fromJson(
      Map<String, dynamic> json) {
    return ExhibitorModel(
      botExhibitorId: json["BotExhibitorId"] ?? 0,
      companyName: json["CompanyName"] ?? "",
      name: json["Name"] ?? "",
      showType: json["ShowType"] ?? "",
      isActive: json["IsActive"] ?? false,
      loginCode: json["logincode"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "BotExhibitorId": botExhibitorId,
      "CompanyName": companyName,
      "Name": name,
      "ShowType": showType,
      "IsActive": isActive,
      "logincode": loginCode,
    };
  }
}