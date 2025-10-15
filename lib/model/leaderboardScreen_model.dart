class LeaderboardScreenModel {
  final int? id;
  final int? bigId;
  final bool? status;
  final String? message;
  final String? refNo;
  final LeaderboardScreenResponse? response;
  final dynamic dataList;
  final dynamic ds;
  final dynamic dt;

  LeaderboardScreenModel({
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

  factory LeaderboardScreenModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardScreenModel(
      id: json["Id"],
      bigId: json["BigId"],
      status: json["status"],
      message: json["message"],
      refNo: json["RefNo"],
      response: json["response"] != null
          ? LeaderboardScreenResponse.fromJson(json["response"])
          : null,
      dataList: json["DataList"],
      ds: json["_ds"],
      dt: json["_dt"],
    );
  }
}

class LeaderboardScreenResponse {
  final String? id;
  final String? refNo;
  final String? region;
  final String? rowRefNo;
  final String? cmpCode;
  final String? entryType;
  final String? userId;
  final String? userId2;
  final int? roleId;
  final int? page;
  final int? totalPage;
  final int? pageSize;
  final List<LeaderboardScreenPlayer>? players;
  final dynamic ds;
  final dynamic dataRow;

  LeaderboardScreenResponse({
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
    this.players,
    this.ds,
    this.dataRow,
  });

  factory LeaderboardScreenResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json["_dt"] as List? ?? [];
    return LeaderboardScreenResponse(
      id: json["Id"],
      refNo: json["RefNo"],
      region: json["Region"],
      rowRefNo: json["RowRefNo"],
      cmpCode: json["Cmp_Code"],
      entryType: json["EntryType"],
      userId: json["UserId"],
      userId2: json["UserId2"],
      roleId: json["RoleId"],
      page: json["Page"],
      totalPage: json["TotalPage"],
      pageSize: json["PageSize"],
      players:
          dataList.map((e) => LeaderboardScreenPlayer.fromJson(e)).toList(),
      ds: json["ds"],
      dataRow: json["_DataRow"],
    );
  }
}

class LeaderboardScreenPlayer {
  final String? playerName;
  final String? stateName;
  final int? handicap;
  final int? score;
  final int? today;
  final int? r1;
  final int? r2;
  final int? r3;
  final int? r4;
  final int? r5;
  final int? r6;
  final int? holeThru;
  final double? totalNet;
  final int? totalGross;
  final String? cmpCode;
  final int? roleId;
  final bool? finalSubmit;

  LeaderboardScreenPlayer({
    this.playerName,
    this.stateName,
    this.handicap,
    this.score,
    this.today,
    this.r1,
    this.r2,
    this.r3,
    this.r4,
    this.r5,
    this.r6,
    this.holeThru,
    this.totalNet,
    this.totalGross,
    this.cmpCode,
    this.roleId,
    this.finalSubmit,
  });

  factory LeaderboardScreenPlayer.fromJson(Map<String, dynamic> json) {
    return LeaderboardScreenPlayer(
      playerName: json["PlayerName"],
      stateName: json["StateName"],
      handicap: json["Handicap"],
      score: json["Score"],
      today: json["Today"],
      r1: json["R1"],
      r2: json["R2"],
      r3: json["R3"],
      r4: json["R4"],
      r5: json["R5"],
      r6: json["R6"],
      holeThru: json["Hole_Thru"],
      totalGross: json["TotalGross"],
      totalNet: json["TotalNet"] != null
          ? (json["TotalNet"]).toDouble()
          : null,
      cmpCode: json["Cmp_Code"],
      roleId: json["RoleId"],
      finalSubmit: json["FinalSubmit"],
    );
  }
}
