class LogoutModel {
  final int id;
  final int bigId;
  final bool status;
  final String? message;
  final String? refNo;
  final String? response;

  LogoutModel({
    required this.id,
    required this.bigId,
    required this.status,
    this.message,
    this.refNo,
    this.response,
  });

  factory LogoutModel.fromJson(Map<String, dynamic> json) {
    return LogoutModel(
      id: json["Id"] ?? 0,
      bigId: json["BigId"] ?? 0,
      status: json["status"] ?? false,
      message: json["message"],
      refNo: json["RefNo"],
      response: json["response"],
    );
  }
}
