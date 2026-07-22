class QrResponse {
  final String status;
  final String refId;
  final String fullName;
  final String companyName;
  final String message;

  QrResponse({
    required this.status,
    required this.refId,
    required this.fullName,
    required this.companyName,
    required this.message,
  });

  factory QrResponse.fromJson(Map<String, dynamic> json) {
    return QrResponse(
      status: json['status'],
      refId: json['refId'],
      fullName: json['FullName'],
      companyName: json['CompanyName'],
      message: json['message'],
    );
  }
}
