class EmailDataResponse {
  final String status;
  final String refId;
  final String fullName;
  final String companyName;
  final String message;

  EmailDataResponse({
    required this.status,
    required this.refId,
    required this.fullName,
    required this.companyName,
    required this.message,
  });

  factory EmailDataResponse.fromJson(Map<String, dynamic> json) {
    return EmailDataResponse(
      status: json["status"] ?? "",
      refId: json["refId"] ?? "",
      fullName: json["FullName"] ?? "",
      companyName: json["CompanyName"] ?? "",
      message: json["message"] ?? "",
    );
  }
}