class EventRegistrationRequest {
  final int? id;
  final String? email;
  final String? homeClub;
  final double? usgaHandicapIndex;
  final String? ghinNo;
  final String? userId;
  final String? cmpCode;
  final String? roleId;
  final String? refNo;
  final String? activateStatus;
  final String? source;
  final String? eventRefNo;
  final double? amount;
  final String? paymentMode;
  final String? status;

  EventRegistrationRequest({
    this.id,
    this.email,
    this.homeClub,
    this.usgaHandicapIndex,
    this.ghinNo,
    this.userId,
    this.cmpCode,
    this.roleId,
    this.refNo,
    this.activateStatus,
    this.source,
    this.eventRefNo,
    this.amount,
    this.paymentMode,
    this.status,
  });

  Map<String, dynamic> toJson() => {
        "Id": id ?? 0,
        "Email": email ?? "",
        "HomeClub": homeClub ?? "",
        "USGAHandicapIndex": usgaHandicapIndex,
        "GHIN_No": ghinNo ?? "",
        "UserId": userId ?? "",
        "Cmp_Code": cmpCode ?? "",
        "RoleId": roleId,
        "RefNo": refNo ?? "",
        "ActivateStatus": activateStatus ?? "",
        "Source": source ?? "",
        "EventRefNo": eventRefNo ?? "",
        "Amount": amount ?? 0.0,
        "PaymentMode": paymentMode ?? "",
        "Status": status ?? "",
      }..removeWhere((key, value) => value == null);
}

/// ✅ Response Model
class EventRegistrationResponse {
  final int? id;
  final int? bigId;
  final bool? status;
  final String? message;
  final String? refNo;
  final EventResponseData? response;

  EventRegistrationResponse({
    this.id,
    this.bigId,
    this.status,
    this.message,
    this.refNo,
    this.response,
  });

  factory EventRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return EventRegistrationResponse(
      id: json['Id'],
      bigId: json['BigId'],
      status: json['status'],
      message: json['message'],
      refNo: json['RefNo'],
      response: json['response'] != null
          ? EventResponseData.fromJson(json['response'])
          : null,
    );
  }
}

/// ✅ Nested "response" field
class EventResponseData {
  final bool? paymentStatus;
  final double? discount;
  final UserData? userData;
  final PaymentData? payment;

  EventResponseData({
    this.paymentStatus,
    this.discount,
    this.userData,
    this.payment,
  });

  factory EventResponseData.fromJson(Map<String, dynamic> json) {
    return EventResponseData(
      paymentStatus: json['PaymentStatus'],
      discount: (json['Discount'] ?? 0).toDouble(),
      userData:
          json['UserData'] != null ? UserData.fromJson(json['UserData']) : null,
      payment:
          json['paymemt'] != null ? PaymentData.fromJson(json['paymemt']) : null,
    );
  }
}

/// ✅ Nested user info
class UserData {
  final String? userName;
  final String? emailId;
  final String? mobileNo;
  final String? cmpCode;

  UserData({
    this.userName,
    this.emailId,
    this.mobileNo,
    this.cmpCode,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userName: json['UserName'],
      emailId: json['EmailId'],
      mobileNo: json['MobileNo'],
      cmpCode: json['Cmp_Code'],
    );
  }
}

/// ✅ Nested payment info
class PaymentData {
  final String? key;
  final String? secret;
  final String? orderId;

  PaymentData({
    this.key,
    this.secret,
    this.orderId,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      key: json['Key'],
      secret: json['Secret'],
      orderId: json['OrderId'],
    );
  }
}
