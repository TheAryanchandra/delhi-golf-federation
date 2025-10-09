class UserDataModel {
  final int id;
  final String name;
  final String phoneNumber;
  final String email;
  final String gender;
  final String password;
  final String dob;
  final int age;
  final String homeClub;
  final double usgaHandicapIndex;
  final String ghinNo;
  final String cmpCode;
  final String? userId;
  final int roleId;
  final String refNo;
  final String? source;
  final String? entryDate;
  final String activateStatus;
  final String? eventRefNo;
  final String? industryRefNo;

  UserDataModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.gender,
    required this.password,
    required this.dob,
    required this.age,
    required this.homeClub,
    required this.usgaHandicapIndex,
    required this.ghinNo,
    required this.cmpCode,
    required this.userId,
    required this.roleId,
    required this.refNo,
    required this.source,
    required this.entryDate,
    required this.activateStatus,
    required this.eventRefNo,
    required this.industryRefNo,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    final response = json['response'] ?? json;

    return UserDataModel(
      id: response['Id'] ?? 0,
      name: response['Name'] ?? '',
      phoneNumber: response['Phonumber'] ?? '',
      email: response['Email'] ?? '',
      gender: response['Gender'] ?? '',
      password: response['Password'] ?? '',
      dob: response['DOB'] ?? '',
      age: response['Age'] ?? 0,
      homeClub: response['HomeClub']?.toString() ?? '',
      usgaHandicapIndex:
          (response['USGA_handicap_index'] ?? 0).toDouble(),
      ghinNo: response['GHIN_No'] ?? '',
      cmpCode: response['Cmp_Code'] ?? '',
      userId: response['UserId']?.toString(),
      roleId: response['RoleId'] ?? 0,
      refNo: response['RefNo'] ?? '',
      source: response['Source']?.toString(),
      entryDate: response['EntryDate']?.toString(),
      activateStatus: response['ActivateStatus'] ?? '',
      eventRefNo: response['EventRefNo']?.toString(),
      industryRefNo: response['IndustryRefNo']?.toString(),
    );
  }
}
