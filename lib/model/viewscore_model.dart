class ViewScoreResponse {
  int? id;
  int? bigId;
  bool? status;
  String? message;
  String? refNo;
  ViewScoreData? response;
  dynamic dataList;
  dynamic ds;
  dynamic dt;

  ViewScoreResponse({
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

  factory ViewScoreResponse.fromJson(Map<String, dynamic> json) {
    return ViewScoreResponse(
      id: json['Id'],
      bigId: json['BigId'],
      status: json['status'],
      message: json['message'],
      refNo: json['RefNo'],
      response: (json['response'] is Map<String, dynamic>)
          ? ViewScoreData.fromJson(json['response'])
          : null,

      dataList: json['DataList'],
      ds: json['_ds'],
      dt: json['_dt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
}

class ViewScoreData {
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
  List<ViewScoreItem>? dt;
  dynamic ds;
  dynamic dataRow;

  ViewScoreData({
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

  factory ViewScoreData.fromJson(Map<String, dynamic> json) {
    List<ViewScoreItem> itemList = [];
    if (json['_dt'] != null && json['_dt'] is List) {
      itemList = (json['_dt'] as List)
          .map((i) => ViewScoreItem.fromJson(i as Map<String, dynamic>))
          .toList();
    }

    return ViewScoreData(
      id: json['Id'],
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
      dt: itemList,
      ds: json['ds'],
      dataRow: json['_DataRow'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      '_dt': dt?.map((v) => v.toJson()).toList(),
      'ds': ds,
      '_DataRow': dataRow,
    };
  }
}

class ViewScoreItem {
  String? dates;
  String? eventName;
  int? holeThru;
  int? par;
  int? indexs;
  int? points;
  String? handicapStatus;
  int? extraNo;

  ViewScoreItem({
    this.dates,
    this.eventName,
    this.holeThru,
    this.par,
    this.indexs,
    this.points,
    this.handicapStatus,
    this.extraNo,
  });

  factory ViewScoreItem.fromJson(Map<String, dynamic> json) {
    return ViewScoreItem(
      dates: json['Dates'],
      eventName: json['EventName'],
      holeThru: json['Hole_Thru'],
      par: json['Par'],
      indexs: json['Indexs'],
      points: json['Points'],
      handicapStatus: json['HandicapStatus'],
      extraNo: json['ExtraNo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Dates': dates,
      'EventName': eventName,
      'Hole_Thru': holeThru,
      'Par': par,
      'Indexs': indexs,
      'Points': points,
      'HandicapStatus': handicapStatus,
      'ExtraNo': extraNo,
    };
  }
}

class ViewScoreRequest {
  int? id;
  int? bigId;
  bool? status;
  String? message;
  String? refNo;
  ViewScoreData? response;
  dynamic dataList;
  dynamic ds;
  dynamic dt;

  ViewScoreRequest({
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

  factory ViewScoreRequest.fromJson(Map<String, dynamic> json) {
    return ViewScoreRequest(
      id: json['Id'] is int
          ? json['Id'] as int
          : json['Id'] is String
              ? int.tryParse(json['Id'] as String)
              : null,
      bigId: json['BigId'] is int
          ? json['BigId'] as int
          : json['BigId'] is String
              ? int.tryParse(json['BigId'] as String)
              : null,
      status: json['status'] is bool
          ? json['status'] as bool
          : (json['status'] != null &&
              json['status'].toString().toLowerCase() == 'true'),
      message: json['message'] != null ? json['message'].toString() : null,
      refNo: json['RefNo'] != null ? json['RefNo'].toString() : null,
      response: (json['response'] is Map<String, dynamic>)
          ? ViewScoreData.fromJson(json['response'])
          : null,
      dataList: json['DataList'],
      ds: json['_ds'],
      dt: json['_dt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
}
