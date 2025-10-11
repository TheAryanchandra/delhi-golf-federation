class EventModel {
  final String? eventType;
  final String? eventName;
  final String? startDate;
  final String? endDate;
  final String? regStartDate;
  final String? regEndDate;
  final String? isRegistrationActive;
  final String? eventActive;
  final String? venue;
  final String? priceMoney;
  final String? content;
  final String? year;
  final String? refNo;
  final String? image;
  final String? pageUrl;
  final String? entryDate;

  EventModel({
    this.eventType,
    this.eventName,
    this.startDate,
    this.endDate,
    this.regStartDate,
    this.regEndDate,
    this.isRegistrationActive,
    this.eventActive,
    this.venue,
    this.priceMoney,
    this.content,
    this.year,
    this.refNo,
    this.image,
    this.pageUrl,
    this.entryDate,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventType: json['EventType'] as String?,
      eventName: json['EventName'] as String?,
      startDate: json['StartDate'] as String?,
      endDate: json['EndDate'] as String?,
      regStartDate: json['RegStartDate'] as String?,
      regEndDate: json['RegEndDate'] as String?,
      isRegistrationActive: json['IsRegistrationActive'] as String?,
      eventActive: json['EventActive'] as String?,
      venue: json['Venue'] as String?,
      priceMoney: json['PriceMoney'] as String?,
      content: json['Content'] as String?,
      year: json['Year'] as String?,
      refNo: json['RefNo'] as String?,
      image: json['Image'] as String?,
      pageUrl: json['PageUrl'] as String?,
      entryDate: json['EntryDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'EventType': eventType,
        'EventName': eventName,
        'StartDate': startDate,
        'EndDate': endDate,
        'RegStartDate': regStartDate,
        'RegEndDate': regEndDate,
        'IsRegistrationActive': isRegistrationActive,
        'EventActive': eventActive,
        'Venue': venue,
        'PriceMoney': priceMoney,
        'Content': content,
        'Year': year,
        'RefNo': refNo,
        'Image': image,
        'PageUrl': pageUrl,
        'EntryDate': entryDate,
      };
}


// ─────────────────────────────────────────────
// NESTED RESPONSE OBJECT
// ─────────────────────────────────────────────

class ResponseData {
  final dynamic id;
  final dynamic refNo;
  final dynamic region;
  final dynamic rowRefNo;
  final dynamic cmpCode;
  final String? entryType;
  final dynamic userId;
  final dynamic userId2;
  final int? roleId;
  final int? page;
  final int? totalPage;
  final int? pageSize;
  final List<EventModel>? dt;
  final dynamic ds;
  final dynamic dataRow;

  ResponseData({
    this.id,
    this.refNo,
    this.region,
    this.rowRefNo,
    this.cmpCode,
    this.entryType,
    this.userId,
    this.userId2,
    this.roleId,
    this.page,
    this.totalPage,
    this.pageSize,
    this.dt,
    this.ds,
    this.dataRow,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    final dtList = json['_dt'] as List?;
    return ResponseData(
      id: json['Id'],
      refNo: json['RefNo'],
      region: json['Region'],
      rowRefNo: json['RowRefNo'],
      cmpCode: json['Cmp_Code'],
      entryType: json['EntryType'] as String?,
      userId: json['UserId'],
      userId2: json['UserId2'],
      roleId: json['RoleId'] as int?,
      page: json['Page'] as int?,
      totalPage: json['TotalPage'] as int?,
      pageSize: json['PageSize'] as int?,
      dt: dtList != null
          ? dtList.map((e) => EventModel.fromJson(e)).toList()
          : [],
      ds: json['ds'],
      dataRow: json['_DataRow'],
    );
  }

  Map<String, dynamic> toJson() => {
        'Id': id,
        'RefNo': refNo,
        'Region': region,
        'RowRefNo': rowRefNo,
        'Cmp_Code': cmpCode,
        'EntryType': entryType,
        'UserId': userId,
        'UserId2': userId2,
        'RoleId': roleId,
        'Page': page,
        'TotalPage': totalPage,
        'PageSize': pageSize,
        '_dt': dt?.map((e) => e.toJson()).toList(),
        'ds': ds,
        '_DataRow': dataRow,
      };
}

// ─────────────────────────────────────────────
// MAIN ROOT MODEL
// ─────────────────────────────────────────────

class EventsResponse {
  final int? id;
  final int? bigId;
  final bool? status;
  final String? message;
  final String? refNo;
  final ResponseData? response;
  final dynamic dataList;
  final dynamic ds;
  final dynamic dt;

  EventsResponse({
    this.id,
    this.bigId,
    this.status,
    this.message,
    this.refNo,
    this.response,
    this.dataList,
    this.ds,
    this.dt,
  });

  factory EventsResponse.fromJson(Map<String, dynamic> json) {
    return EventsResponse(
      id: json['Id'] as int?,
      bigId: json['BigId'] as int?,
      status: json['status'] as bool?,
      message: json['message'] as String?,
      refNo: json['RefNo'] as String?,
      response: json['response'] != null
          ? ResponseData.fromJson(json['response'])
          : null,
      dataList: json['DataList'],
      ds: json['_ds'],
      dt: json['_dt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'Id': id,
        'BigId': bigId,
        'status': status,
        'message': message,
        'RefNo': refNo,
        'response': response?.toJson(),
        'DataList': dataList,
        '_ds': ds,
        '_dt': dt,
      };
}
