class LoginResponse {
  final bool status;
  final String message;
  final String? token;
  final String? refNo;
  final List<String>? dataList;

  LoginResponse({
    required this.status,
    required this.message,
    this.token,
    this.refNo,
    this.dataList,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'], // ✅ correct lowercase + safe cast
      message: json['message']?.toString() ?? '',
      token: json['response']?.toString(),
      refNo: json['RefNo']?.toString(),
      dataList: (json['DataList'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }
}
