class WorldOfGolfItem {
  final int id;
  final String venue;
  final String refNo;

  WorldOfGolfItem({
    required this.id,
    required this.venue,
    required this.refNo,
  });

  factory WorldOfGolfItem.fromJson(Map<String, dynamic> json) {
    return WorldOfGolfItem(
      id: json['Id'] ?? 0,
      venue: json['Venue'] ?? '',
      refNo: json['RefNo'] ?? '',
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
  final int page;
  final int pageSize;

  WorldOfGolfPayload({
    required this.action,
    required this.entryType,
    this.page = 1,
    this.pageSize = 20,
  });

  Map<String, dynamic> toJson() {
    return {
      "Id": "",
      "RefNo": "",
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
      "_DataRow": null
    };
  }
}
