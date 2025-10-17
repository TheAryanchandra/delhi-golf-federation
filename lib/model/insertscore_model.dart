class LeaderboardRequest {
  int? id;
  String? stateName;
  String? playerName;
  String? dates;
  double? handicap;
  int? score;
  int? today;
  int? extraPoint;
  int? dayScore;
  int? holeThru;
  int? par;
  int? indexs;
  int? totalGross;
  int? totalNet;
  String? courseRefNo;
  String? eventRefNo;
  String? eventRegNo;
  String? handicapStatus; // ✅ Added field
  bool? finalSubmit;

  LeaderboardRequest({
    this.id,
    this.stateName,
    this.playerName,
    this.dates,
    this.handicap,
    this.score,
    this.today,
    this.extraPoint,
    this.dayScore,
    this.holeThru,
    this.par,
    this.indexs,
    this.totalGross,
    this.totalNet,
    this.courseRefNo,
    this.eventRefNo,
    this.eventRegNo,
    this.handicapStatus, // ✅ Added in constructor
    this.finalSubmit,
  });

  Map<String, dynamic> toJson() => {
        "Id": id,
        "StateName": stateName,
        "PlayerName": playerName,
        "Dates": dates,
        "Handicap": handicap,
        "Score": score,
        "Today": today,
        "ExtraPoint": extraPoint,
        "DayScore": dayScore,
        "Hole_Thru": holeThru,
        "Par": par,
        "Indexs": indexs,
        "TotalGross": totalGross,
        "TotalNet": totalNet,
        "CourseRefNo": courseRefNo,
        "EventRefNo": eventRefNo,
        "EventRegNo": eventRegNo,
        "HandicapStatus": handicapStatus, // ✅ Added in payload
        "FinalSubmit": finalSubmit,
      };
}



class LeaderboardResponse {
  final int? id;
  final int? bigId;
  final bool? status;
  final String? message;

  LeaderboardResponse({
    this.id,
    this.bigId,
    this.status,
    this.message,
  });

  factory LeaderboardResponse.fromJson(Map<String, dynamic> json) {
    return LeaderboardResponse(
      id: json['Id'],
      bigId: json['BigId'],
      status: json['status'],
      message: json['message'],
    );
  }
}
