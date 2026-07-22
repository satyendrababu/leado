class ShowInfoModel {
  final String pageName;
  final String showinfoText;

  ShowInfoModel({
    required this.pageName,
    required this.showinfoText,
  });

  factory ShowInfoModel.fromJson(Map<String, dynamic> json) {
    return ShowInfoModel(
      pageName: json["pageName"] ?? "",
      showinfoText: json["showinfoText"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "pageName": pageName,
      "showinfoText": showinfoText,
    };
  }
}