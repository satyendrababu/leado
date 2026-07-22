class HelpDeskModel {
  final String pageName;
  final String helpDeskText;

  HelpDeskModel({
    required this.pageName,
    required this.helpDeskText,
  });

  factory HelpDeskModel.fromJson(Map<String, dynamic> json) {
    return HelpDeskModel(
      pageName: json["pageName"] ?? "",
      helpDeskText: json["helpDeskText"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "pageName": pageName,
      "helpDeskText": helpDeskText,
    };
  }
}