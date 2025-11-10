class WorldOfGolfItem {
  final int id;
  final String venue;
  final String refNo;

  // 🔹 Add these optional fields for News
  final String? eventType;
  final String? eventName;
  final String? startDate;
  final String? content;
  final String? image;

  WorldOfGolfItem({
    required this.id,
    required this.venue,
    required this.refNo,
    this.eventType,
    this.eventName,
    this.startDate,
    this.content,
    this.image,
  });

  factory WorldOfGolfItem.fromJson(Map<String, dynamic> json) {
    return WorldOfGolfItem(
      id: json['Id'] ?? 0,
      venue: json['Venue'] ?? '',
      refNo: json['RefNo'] ?? '',
      eventType: json['EventType'] ?? '',
      eventName: json['EventName'] ?? '',
      startDate: json['StartDate'] ?? '',
      content: json['Content'] ?? '',
      image: json['Image'] ?? '',
    );
  }
}

class WorldOfGolfResponse {
  final bool status;
  final String message;
  final int totalPage;
  final int page;
  final List<WorldOfGolfItem> items;

  WorldOfGolfResponse({
    required this.status,
    required this.message,
    required this.totalPage,
    required this.page,
    required this.items,
  });

  factory WorldOfGolfResponse.fromJson(Map<String, dynamic> json) {
    final response = json['response'] ?? {};
    final List<dynamic> dt = response['_dt'] ?? [];

    return WorldOfGolfResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      totalPage: response['TotalPage'] ?? 0,
      page: response['Page'] ?? 1,
      items: dt.map((e) => WorldOfGolfItem.fromJson(e)).toList(),
    );
  }
}

class WorldOfGolfPayload {
  final String action;
  final String entryType;
  final String id; // 🔹 Added for News (Latest/Past)
  final String? refNo; // 🔹 Added for News single data
  final int page;
  final int pageSize;

  WorldOfGolfPayload({
    required this.action,
    required this.entryType,
    this.id = "", // default empty for Gallery
    this.refNo, // 🔹 Added
    this.page = 1,
    this.pageSize = 20,
  });

  Map<String, dynamic> toJson() {
    return {
      "Id": id, // 🔹 Used for News (Latest / Past)
      "RefNo": refNo ?? "",
      "Region": "",
      "RowRefNo": "",
      "Cmp_Code": "",
      "Dates": "",
      "EventRefNo": "",
      "EventRegNo": "",
      "EntryType": entryType,
      "IsActive": "True",
      "FinalSubmit": true,
      "UserId": "",
      "Action": action,
      "UserId2": "",
      "RoleId": 3,
      "Page": page,
      "TotalPage": 10,
      "PageSize": pageSize,
      "_dt": null,
      "ds": null,
      "_DataRow": null,
    };
  }
}
