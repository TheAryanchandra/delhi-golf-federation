class IndustryModel {
  final int id;
  final String name;
  final String refNo;

  IndustryModel({
    required this.id,
    required this.name,
    required this.refNo,
  });

  factory IndustryModel.fromJson(Map<String, dynamic> json) {
    return IndustryModel(
      id: json['Id'] ?? 0,
      name: json['Name'] ?? '',
      refNo: json['RefNo'] ?? '',
    );
  }
}

class IndustryResponse {
  final bool status;
  final String message;
  final List<IndustryModel> industries;

  IndustryResponse({
    required this.status,
    required this.message,
    required this.industries,
  });

  factory IndustryResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['_dt'] as List?)
            ?.map((item) => IndustryModel.fromJson(item))
            .toList() ??
        [];

    return IndustryResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      industries: list,
    );
  }
}
