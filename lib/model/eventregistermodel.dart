class EventRegistrationRequest {
  final int id;
  final String name;
  final String phonumber;
  final String email;
  final String gender;
  final String password;
  final String dob;
  final int age;
  final String homeClub;
  final double usgaHandicapIndex;
  final String ghinNo;
  final String? cmpCode;
  final String? roleId;
  final String eventRefNo;
  final String source;

  EventRegistrationRequest({
    required this.id,
    required this.name,
    required this.phonumber,
    required this.email,
    required this.gender,
    required this.password,
    required this.dob,
    required this.age,
    required this.homeClub,
    required this.usgaHandicapIndex,
    required this.ghinNo,
    this.cmpCode,
    this.roleId,
    required this.eventRefNo,
    required this.source,
  });

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "Phonumber": phonumber,
        "Email": email,
        "Gender": gender,
        "Password": password,
        "DOB": dob,
        "Age": age,
        "HomeClub": homeClub,
        "USGA_handicap_index": usgaHandicapIndex,
        "GHIN_No": ghinNo,
        "Cmp_Code": cmpCode,
        "RoleId": roleId,
        "EventRefNo": eventRefNo,
        "Source": source,
      };
}

class EventRegistrationResponse {
  final bool success;
  final String message;

  EventRegistrationResponse({
    required this.success,
    required this.message,
  });

  factory EventRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return EventRegistrationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
