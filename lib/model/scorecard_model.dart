class EventScoreRequest {
  final String eventRefNo;
  final String regEventRefNo;
  final String courseRefNo;
  final String? date;
  final String? cmpCode;
  final int roleId;
  final String action;

  EventScoreRequest({
    required this.eventRefNo,
    required this.regEventRefNo,
    required this.courseRefNo,
    this.date,
    this.cmpCode,
    this.roleId = 0,
    this.action = "getScore",
  });

  Map<String, dynamic> toJson() {
    return {
      "EventRefNo": eventRefNo,
      "RegEventRefNo": regEventRefNo,
      "CourseRefNo": courseRefNo,
      "Date": date,
      "Cmp_Code": cmpCode,
      "RoleId": roleId,
      "Action": action,
    };
  }
}

class EventScoreResponse {
  bool? status;
  String? message;
  dynamic dataList;
  DsData? ds;

  EventScoreResponse({this.status, this.message, this.dataList, this.ds});

  factory EventScoreResponse.fromJson(Map<String, dynamic> json) {
    return EventScoreResponse(
      status: json['status'],
      message: json['message'],
      dataList: json['DataList'],
      ds: json['_ds'] != null ? DsData.fromJson(json['_ds']) : null,
    );
  }
}

class DsData {
  List<TotalHole>? table;
  List<PlayerInfo>? table1;
  List<HoleInfo>? table2;

  DsData({this.table, this.table1, this.table2});

  factory DsData.fromJson(Map<String, dynamic> json) {
    return DsData(
      table: json['Table'] != null
          ? List<TotalHole>.from(
              json['Table'].map((x) => TotalHole.fromJson(x)),
            )
          : [],
      table1: json['Table1'] != null
          ? List<PlayerInfo>.from(
              json['Table1'].map((x) => PlayerInfo.fromJson(x)),
            )
          : [],
      table2: json['Table2'] != null
          ? List<HoleInfo>.from(json['Table2'].map((x) => HoleInfo.fromJson(x)))
          : [],
    );
  }
}

class TotalHole {
  int? totalHole;
  TotalHole({this.totalHole});
  factory TotalHole.fromJson(Map<String, dynamic> json) =>
      TotalHole(totalHole: json['TotalHole']);
}

class PlayerInfo {
  String? name;
  String? courseName;
  double? usgaHandicapIndex;

  PlayerInfo({this.name, this.courseName, this.usgaHandicapIndex});

  factory PlayerInfo.fromJson(Map<String, dynamic> json) => PlayerInfo(
    name: json['Name'],
    courseName: json['CourseName'],
    usgaHandicapIndex: (json['USGA_handicap_index'] as num?)?.toDouble(),
  );
}

class HoleInfo {
  int? hole;
  int? par;
  int? indexNo;
  int? score;

  HoleInfo({this.hole, this.par, this.indexNo, this.score});

  factory HoleInfo.fromJson(Map<String, dynamic> json) => HoleInfo(
    hole: json['Hole'],
    par: json['Par'],
    indexNo: json['IndexNo'],
    score: json['Score'],
  );
}
