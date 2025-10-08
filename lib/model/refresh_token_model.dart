class RefreshTokenModel {
  final bool status;
  final String message;
  final String refNo;
  final String response; // new JWT token
  final List<String>? dataList;

  RefreshTokenModel({
    required this.status,
    required this.message,
    required this.refNo,
    required this.response,
    this.dataList,
  });

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      refNo: json['RefNo'] ?? '',
      response: json['response'] ?? '',
      dataList: json['DataList'] != null
          ? List<String>.from(json['DataList'])
          : [],
    );
  }
}
