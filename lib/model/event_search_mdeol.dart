class EventSearchModel {
  // Core fields
  String? id; // now a string
  String? refNo;
  String? name;
  String? profileFile;
  int? position;
  int? score;
  double? point;
  String? eventRefNo;

  // Additional payload fields
  String? region;
  String? rowRefNo;
  String? cmpCode;
  String? dates;
  String? eventRegNo;
  String? entryType;
  String? isActive;
  bool? finalSubmit;
  String? userId;
  String? action;
  String? userId2;
  int? roleId;
  int? page;
  int? totalPage;
  int? pageSize;
  dynamic dt;
  dynamic ds;
  dynamic dataRow;

  EventSearchModel({
    this.id,
    this.refNo,
    this.name,
    this.profileFile,
    this.position,
    this.score,
    this.point,
    this.eventRefNo,
    this.region,
    this.rowRefNo,
    this.cmpCode,
    this.dates,
    this.eventRegNo,
    this.entryType,
    this.isActive,
    this.finalSubmit,
    this.userId,
    this.action,
    this.userId2,
    this.roleId,
    this.page,
    this.totalPage,
    this.pageSize,
    this.dt,
    this.ds,
    this.dataRow,
  });

  factory EventSearchModel.fromJson(Map<String, dynamic> json) {
    return EventSearchModel(
      id: json['Id']?.toString(),
      refNo: json['RefNo'],
      name: json['Name'],
      profileFile: json['Profilefile'],
      position: json['Position'],
      score: json['Score'],
      point: (json['point'] is int)
          ? (json['point'] as int).toDouble()
          : (json['point'] ?? 0).toDouble(),
      eventRefNo: json['EventRefNo'],
      region: json['Region'],
      rowRefNo: json['RowRefNo'],
      cmpCode: json['Cmp_Code'],
      dates: json['Dates'],
      eventRegNo: json['EventRegNo'],
      entryType: json['EntryType'],
      isActive: json['IsActive'],
      finalSubmit: json['FinalSubmit'],
      userId: json['UserId'],
      action: json['Action'],
      userId2: json['UserId2'],
      roleId: json['RoleId'],
      page: json['Page'],
      totalPage: json['TotalPage'],
      pageSize: json['PageSize'],
      dt: json['_dt'],
      ds: json['ds'],
      dataRow: json['_DataRow'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Id": id,
      "RefNo": refNo,
      "Name": name,
      "Profilefile": profileFile,
      "Position": position,
      "Score": score,
      "point": point,
      "EventRefNo": eventRefNo,
      "Region": region,
      "RowRefNo": rowRefNo,
      "Cmp_Code": cmpCode,
      "Dates": dates,
      "EventRegNo": eventRegNo,
      "EntryType": entryType,
      "IsActive": isActive,
      "FinalSubmit": finalSubmit,
      "UserId": userId,
      "Action": action,
      "UserId2": userId2,
      "RoleId": roleId,
      "Page": page,
      "TotalPage": totalPage,
      "PageSize": pageSize,
      "_dt": dt,
      "ds": ds,
      "_DataRow": dataRow,
    };
  }

  /// Getter for backward compatibility
  String? get eventName => name;
}

/// Full response wrapper
class EventSearchResponse {
  bool? status;
  String? message;
  List<EventSearchModel>? eventList;

  EventSearchResponse({this.status, this.message, this.eventList});

  factory EventSearchResponse.fromJson(Map<String, dynamic> json) {
    final List<EventSearchModel> events = [];

    // Access _dt directly from root
    if (json['_dt'] != null) {
      for (var item in json['_dt']) {
        events.add(EventSearchModel.fromJson(item));
      }
    }

    return EventSearchResponse(
      status: json['status'],
      message: json['message'],
      eventList: events,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      '_dt': eventList?.map((e) => e.toJson()).toList(),
    };
  }
}
