class UpdateProfileModel {
  int? id;
  String? name;
  String? phonumber;
  String? email;
  String? gender;
  String? dob;
  double? usgaHandicapIndex;
  String? cmpCode;
  String? refNo;
  String? activateStatus;
  String? homeClub;

  UpdateProfileModel({
    this.id,
    this.name,
    this.phonumber,
    this.email,
    this.gender,
    this.dob,
    this.usgaHandicapIndex,
    this.cmpCode,
    this.refNo,
    this.activateStatus,
    this.homeClub,
  });

  Map<String, dynamic> toJson() => {
        "Id": id ?? 0,
        "Name": name ?? "",
        "Phonumber": phonumber ?? "",
        "Email": email ?? "",
        "Gender": gender ?? "",
        "Password": "",
        "DOB": dob ?? "",
        "Age": 0,
        "HomeClub": homeClub ?? "",
        "USGA_handicap_index": usgaHandicapIndex ?? 0.0,
        "GHIN_No": "",
        "Cmp_Code": cmpCode ?? "",
        "UserId": null,
        "RoleId": 0,
        "RefNo": refNo ?? "",
        "Source": null,
        "EntryDate": null,
        "ActivateStatus": activateStatus ?? "Activate",
        "EventRefNo": null,
        "IndustryRefNo": "",
        "Reason": null,
        "ProfileImg": null, // ✅ keep null — the image goes separately as 'img'
      };
}
