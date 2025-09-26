class RegistrationRequestModel {
  final int? id;
  final String? name;
  final String? phonumber;
  final String? email;
  final String? gender;
  final String? password;
  final String? dob;
  final int? age;
  final String? homeClub;
  final double? usgaHandicapIndex;
  final String? ghinNo;
  final String? cmpCode;
  final int? roleId;
  final String? refNo;
  final String? source;

  RegistrationRequestModel({
    this.id,
    this.name,
    this.phonumber,
    this.email,
    this.gender,
    this.password,
    this.dob,
    this.age,
    this.homeClub,
    this.usgaHandicapIndex,
    this.ghinNo,
    this.cmpCode,
    this.roleId,
    this.refNo,
    this.source,
  });

  Map<String, dynamic> toJson() {
    return {
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
      "RefNo": refNo,
      "Source": source,
    };
  }
}

class RegistrationResponseModel {
  final int? id;
  final int? bigId;
  final bool? status;
  final String? message;
  final String? refNo;
  final dynamic response;

  RegistrationResponseModel({
    this.id,
    this.bigId,
    this.status,
    this.message,
    this.refNo,
    this.response,
  });

  factory RegistrationResponseModel.fromJson(Map<String, dynamic> json) {
    return RegistrationResponseModel(
      id: json['Id'],
      bigId: json['BigId'],
      status: json['status'],
      message: json['message'],
      refNo: json['RefNo'],
      response: json['response'],
    );
  }
}





