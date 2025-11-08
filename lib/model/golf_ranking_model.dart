class GolfRankingRequest {
  String? id;
  String? refNo;
  String? region;
  String? rowRefNo;
  String? cmpCode;
  String? dates;
  String? eventRefNo;
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
  dynamic dt; // ✅ instead of _dt
  dynamic ds;
  dynamic dataRow; // ✅ instead of _DataRow

  GolfRankingRequest({
    this.id,
    this.refNo,
    this.region,
    this.rowRefNo,
    this.cmpCode,
    this.dates,
    this.eventRefNo,
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

  Map<String, dynamic> toJson() => {
        "Id": id,
        "RefNo": refNo,
        "Region": region,
        "RowRefNo": rowRefNo,
        "Cmp_Code": cmpCode,
        "Dates": dates,
        "EventRefNo": eventRefNo,
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
        "_dt": dt, // ✅ match JSON key
        "ds": ds,
        "_DataRow": dataRow,
      };
}

class GolfRankingResponse {
  int? id;
  int? bigId;
  bool? status;
  String? message;
  String? refNo;
  ResponseData? response;

  GolfRankingResponse({
    this.id,
    this.bigId,
    this.status,
    this.message,
    this.refNo,
    this.response,
  });

  factory GolfRankingResponse.fromJson(Map<String, dynamic> json) =>
      GolfRankingResponse(
        id: json["Id"],
        bigId: json["BigId"],
        status: json["status"],
        message: json["message"],
        refNo: json["RefNo"],
        response: json["response"] != null
            ? ResponseData.fromJson(json["response"])
            : null,
      );
}

class ResponseData {
  int? totalPage;
  List<GolfPlayer>? players;

  ResponseData({
    this.totalPage,
    this.players,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
        totalPage: json["TotalPage"],
        players: json["_dt"] == null
            ? []
            : List<GolfPlayer>.from(
                json["_dt"].map((x) => GolfPlayer.fromJson(x))),
      );
}

class GolfPlayer {
  int? id;
  String? name;
  String? rankType;
  int? ranks;
  int? stateRank;
  double? totalScore;
  String? genseType;
  String? genseTitle;
  String? genseCategory;
  String? genseCategoryTitle;
  String? entryDate;
  String? updateDate;
  String? refNo;

  GolfPlayer({
    this.id,
    this.name,
    this.rankType,
    this.ranks,
    this.stateRank,
    this.totalScore,
    this.genseType,
    this.genseTitle,
    this.genseCategory,
    this.genseCategoryTitle,
    this.entryDate,
    this.updateDate,
    this.refNo,
  });

  factory GolfPlayer.fromJson(Map<String, dynamic> json) => GolfPlayer(
        id: json["Id"],
        name: json["Name"],
        rankType: json["RankType"],
        ranks: json["Ranks"],
        stateRank: json["StateRank"],
        totalScore: (json["TotalScore"] != null)
            ? double.tryParse(json["TotalScore"].toString())
            : null,
        genseType: json["GenseType"],
        genseTitle: json["GenseTitle"],
        genseCategory: json["GenseCategory"],
        genseCategoryTitle: json["GenseCategoryTitle"],
        entryDate: json["EntryDate"],
        updateDate: json["UpdateDate"],
        refNo: json["RefNo"],
      );
}
