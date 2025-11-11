class GolfClubGolfersRankingRequest {
  String? id;
  String? refNo;
  String entryType;
  bool finalSubmit;
  int? roleId;
  int? page;
  int? pageSize;
  String action;

  GolfClubGolfersRankingRequest({
    this.id,
    this.refNo,
    this.entryType = "Event",
    this.finalSubmit = true,
    this.roleId,
    this.page,
    this.pageSize,
    this.action = "GetUpcomingEvents",
  });

  Map<String, dynamic> toJson() {
    return {
      "Id": id ?? "",
      "RefNo": refNo ?? "",
      "Region": "",
      "RowRefNo": "",
      "Cmp_Code": "",
      "Dates": "",
      "EventRefNo": "",
      "EventRegNo": "",
      "EntryType": entryType,
      "IsActive": "True",
      "FinalSubmit": finalSubmit,
      "UserId": "",
      "Action": action,
      "UserId2": "",
      "RoleId": roleId ?? 0,
      "Page": page ?? 1,
      "TotalPage": 0,
      "PageSize": pageSize ?? 20,
      "_dt": null,
      "ds": null,
      "_DataRow": null,
    };
  }
}

class GolfClubGolfersRankingResponse {
  int? id;
  bool? status;
  String? message;
  GolfClubGolfersRankingResponseData? response;

  GolfClubGolfersRankingResponse({
    this.id,
    this.status,
    this.message,
    this.response,
  });

  factory GolfClubGolfersRankingResponse.fromJson(Map<String, dynamic> json) {
    return GolfClubGolfersRankingResponse(
      id: json['Id'] is int ? json['Id'] : int.tryParse(json['Id']?.toString() ?? ''),
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      response: json['response'] != null
          ? GolfClubGolfersRankingResponseData.fromJson(json['response'])
          : null,
    );
  }
}

class GolfClubGolfersRankingResponseData {
  String? id;
  String? refNo;
  List<GolfClubGolfer>? players;

  GolfClubGolfersRankingResponseData({
    this.id,
    this.refNo,
    this.players,
  });

  factory GolfClubGolfersRankingResponseData.fromJson(Map<String, dynamic> json) {
    final dataList = json['_dt'];
    List<GolfClubGolfer> playersList = [];

    if (dataList is List) {
      playersList = dataList.map((e) => GolfClubGolfer.fromJson(e)).toList();
    }

    return GolfClubGolfersRankingResponseData(
      id: json['Id']?.toString(),
      refNo: json['RefNo']?.toString(),
      players: playersList,
    );
  }
}

class GolfClubGolfer {
  String? profileFile;
  String? name;
  int? position;
  int? score;
  double? point;
  String? eventRefNo;

  GolfClubGolfer({
    this.profileFile,
    this.name,
    this.position,
    this.score,
    this.point,
    this.eventRefNo,
  });

  factory GolfClubGolfer.fromJson(Map<String, dynamic> json) {
    return GolfClubGolfer(
      profileFile: json['Profilefile']?.toString(),
      name: json['Name']?.toString(),
      position: json['Position'] is int
          ? json['Position']
          : int.tryParse(json['Position']?.toString() ?? ''),
      score: json['Score'] is int
          ? json['Score']
          : int.tryParse(json['Score']?.toString() ?? ''),
      point: json['point'] is num
          ? (json['point'] as num).toDouble()
          : double.tryParse(json['point']?.toString() ?? '0') ?? 0.0,
      eventRefNo: json['EventRefNo']?.toString(),
    );
  }
}
