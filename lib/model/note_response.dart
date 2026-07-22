class NoteResponse {
  final String status;
  final String refId;
  final String message;

  NoteResponse({
    required this.status,
    required this.refId,
    required this.message,
  });

  factory NoteResponse.fromJson(Map<String, dynamic> json) {
    return NoteResponse(
      status: json["status"] ?? "",
      refId: json["refId"] ?? "",
      message: json["message"] ?? "",
    );
  }
}