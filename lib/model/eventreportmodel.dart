class EventReportRequest {
  int? id;
  String? refNo;
  String? region;
  String? rowRefNo;
  String? cmpCode;
  String? entryType;
  String? userId;
  String? userId2;
  int? roleId;
  int? page;
  int? totalPage;
  int? pageSize;
  dynamic dt;
  dynamic ds;
  dynamic dataRow;

  EventReportRequest({
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
    this.pageSize = 5,
    this.dt,
    this.ds,
    this.dataRow,
  });

  Map<String, dynamic> toJson() {
    return {
      "Id": id,
      "RefNo": refNo,
      "Region": region,
      "RowRefNo": rowRefNo,
      "Cmp_Code": cmpCode,
      "EntryType": entryType,
      "UserId": userId,
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
}

class EventReportResponse {
  int? id;
  int? bigId;
  bool? status;
  String? message;
  String? refNo;
  ResponseData? response;
  dynamic dataList;
  dynamic ds;
  dynamic dt;

  EventReportResponse({
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

  factory EventReportResponse.fromJson(Map<String, dynamic> json) {
    // 🧩 Handle both string and map types for 'response'
    final responseField = json['response'];
    ResponseData? parsedResponse;

    if (responseField is Map<String, dynamic>) {
      parsedResponse = ResponseData.fromJson(responseField);
    } else {
      parsedResponse = null; // empty string, null, etc.
    }

    return EventReportResponse(
      id: json['Id'],
      bigId: json['BigId'],
      status: json['status'],
      message: json['message'],
      refNo: json['RefNo'],
      response: parsedResponse,
      dataList: json['DataList'],
      ds: json['_ds'],
      dt: json['_dt'],
    );
  }
}

class ResponseData {
  String? id;
  String? refNo;
  String? region;
  String? rowRefNo;
  String? cmpCode;
  String? entryType;
  String? userId;
  String? userId2;
  int? roleId;
  int? page;
  int? totalPage;
  int? pageSize;
  List<EventData>? dt;
  dynamic ds;
  dynamic dataRow;

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
    return ResponseData(
      id: json['Id']?.toString(),
      refNo: json['RefNo'],
      region: json['Region'],
      rowRefNo: json['RowRefNo'],
      cmpCode: json['Cmp_Code'],
      entryType: json['EntryType'],
      userId: json['UserId'],
      userId2: json['UserId2'],
      roleId: json['RoleId'],
      page: json['Page'],
      totalPage: json['TotalPage'],
      pageSize: json['PageSize'],
      dt: json['_dt'] != null
          ? List<EventData>.from(
              (json['_dt'] as List).map((x) => EventData.fromJson(x)))
          : [],
      ds: json['ds'],
      dataRow: json['_DataRow'],
    );
  }
}

class EventData {
  String? eventType;
  String? eventName;
  String? startDate;
  String? endDate;
  String? regStartDate;
  String? regEndDate;
  String? regRefNo;
  String? courseRefNo;
  String? venue;
  String? priceMoney;
  String? content;
  String? year;
  String? refNo;
  String? image;
  String? pageUrl;
  String? entryDate;
  String? handicap;

  EventData({
    this.eventType,
    this.eventName,
    this.startDate,
    this.endDate,
    this.regStartDate,
    this.regEndDate,
    this.regRefNo,
    this.courseRefNo,
    this.venue,
    this.priceMoney,
    this.content,
    this.year,
    this.refNo,
    this.image,
    this.pageUrl,
    this.entryDate,
    this.handicap,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      eventType: json['EventType'],
      eventName: json['EventName'],
      startDate: json['StartDate'],
      endDate: json['EndDate'],
      regStartDate: json['RegStartDate'],
      regEndDate: json['RegEndDate'],
      regRefNo: json['Reg_RefNo'],
      courseRefNo: json['CourseRefNo'],
      venue: json['Venue'],
      priceMoney: json['PriceMoney'],
      content: json['Content'],
      year: json['Year'],
      refNo: json['RefNo'],
      image: json['Image'],
      pageUrl: json['PageUrl'],
      entryDate: json['EntryDate'],
      handicap: json['Handicap'],
    );
  }
}
