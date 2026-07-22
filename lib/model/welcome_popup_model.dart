class WelcomePopupModel {
  final String pageName;
  final String photo;
  final String popupText;

  WelcomePopupModel({
    required this.pageName,
    required this.photo,
    required this.popupText,
  });

  factory WelcomePopupModel.fromJson(Map<String, dynamic> json) {
    return WelcomePopupModel(
      pageName: json["pageName"] ?? "",
      photo: json["photo"] ?? "",
      popupText: json["popupText"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "pageName": pageName,
        "photo": photo,
        "popupText": popupText,
      };
}