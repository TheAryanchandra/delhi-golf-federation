class LeaderboardRequest {
  final int id;
  final String stateName;
  final String playerName;
  final String dates;
  final int handicap;
  final int score;
  final int today;
  final int extraPoint;
  final int dayScore;
  final int holeThru;
  final int par;       // <-- added
  final int indexs;    // <-- added
  final int totalGross;
  final int totalNet;
  final String courseRefNo;
  final String eventRefNo;
  final String eventRegNo;
  final bool finalSubmit;

  LeaderboardRequest({
    required this.id,
    required this.stateName,
    required this.playerName,
    required this.dates,
    required this.handicap,
    required this.score,
    required this.today,
    required this.extraPoint,
    required this.dayScore,
    required this.holeThru,
    required this.par,
    required this.indexs,
    required this.totalGross,
    required this.totalNet,
    required this.courseRefNo,
    required this.eventRefNo,
    required this.eventRegNo,
    required this.finalSubmit,
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
        "Par": par,         // <-- added
        "Indexs": indexs,   // <-- added
        "TotalGross": totalGross,
        "TotalNet": totalNet,
        "CourseRefNo": courseRefNo,
        "EventRefNo": eventRefNo,
        "EventRegNo": eventRegNo,
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
