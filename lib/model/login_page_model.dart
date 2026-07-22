class LoginPageModel {
  final String pageName;
  final String logo;
  final String title;
  final String welcomeText;
  final String loginText;
  final List<ShowModel> shows;

  LoginPageModel({
    required this.pageName,
    required this.logo,
    required this.title,
    required this.welcomeText,
    required this.loginText,
    required this.shows,
  });

  factory LoginPageModel.fromJson(Map<String, dynamic> json) {
    return LoginPageModel(
      pageName: json["pageName"] ?? "",
      logo: json["logo"] ?? "",
      title: json["title"] ?? "",
      welcomeText: json["welcomeText"] ?? "",
      loginText: json["loginText"] ?? "",
      shows: (json["shows"] as List)
          .map((e) => ShowModel.fromJson(e))
          .toList(),
    );
  }
}

class ShowModel {
  final String showCode;
  final String showName;
  final String activeStatus;

  ShowModel({
    required this.showCode,
    required this.showName,
    required this.activeStatus,
  });

  factory ShowModel.fromJson(Map<String, dynamic> json) {
    return ShowModel(
      showCode: json["showCode"] ?? "",
      showName: json["showName"] ?? "",
      activeStatus: json["ActiveStatus"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "showCode": showCode,
      "showName": showName,
      "ActiveStatus": activeStatus,
    };
  }
}