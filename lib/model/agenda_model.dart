class AgendaModel {
  final String pageName;
  final String agendaText;

  AgendaModel({
    required this.pageName,
    required this.agendaText,
  });

  factory AgendaModel.fromJson(Map<String, dynamic> json) {
    return AgendaModel(
      pageName: json["pageName"] ?? "",
      agendaText: json["agendaText"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "pageName": pageName,
      "agendaText": agendaText,
    };
  }
}