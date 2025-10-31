class LoginResponse {
  final bool status;
  final String message;
  final String? token;
  final String? refNo;
  final List<String>? dataList;
  final int? statusCode;
  final ResponseData? response; // ✅ Added
  final List<MembershipPlan>? membershipPlans; // ✅ Added

  LoginResponse({
    required this.status,
    required this.message,
    this.token,
    this.refNo,
    this.dataList,
    this.statusCode,
    this.response,
    this.membershipPlans,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json, {int? statusCode}) {
    dynamic responseValue = json['response'];
    ResponseData? responseData;
    String? token;

    if (responseValue is Map<String, dynamic>) {
      responseData = ResponseData.fromJson(responseValue);
    } else if (responseValue is String) {
      token = responseValue;
    }

    return LoginResponse(
      status: json['status'] ?? false,
      message: json['message']?.toString() ?? '',
      token: token ?? json['response']?.toString(),
      refNo: json['RefNo']?.toString(),
      dataList: (json['DataList'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      statusCode: statusCode,
      response: responseData,
      membershipPlans: (json['_dt'] as List<dynamic>?)
          ?.map((e) => MembershipPlan.fromJson(e))
          .toList(), // ✅ Parse membership list
    );
  }
}

class ResponseData {
  final String? userName;
  final String? emailId;
  final String? mobileNo;
  final String? cmpCode;
  final PaymentData? payment;

  ResponseData({
    this.userName,
    this.emailId,
    this.mobileNo,
    this.cmpCode,
    this.payment,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      userName: json['UserName']?.toString(),
      emailId: json['EmailId']?.toString(),
      mobileNo: json['MobileNo']?.toString(),
      cmpCode: json['Cmp_Code']?.toString(),
      payment: json['paymemt'] != null
          ? PaymentData.fromJson(json['paymemt'])
          : null,
    );
  }
}

class PaymentData {
  final String? key;
  final String? secret;

  PaymentData({this.key, this.secret});

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      key: json['Key']?.toString(),
      secret: json['Secret']?.toString(),
    );
  }
}

class MembershipPlan {
  final String? membershipType;
  final double? amount;
  final double? discount;
  final String? refNo;

  MembershipPlan({this.membershipType, this.amount, this.discount, this.refNo});

  factory MembershipPlan.fromJson(Map<String, dynamic> json) {
    return MembershipPlan(
      membershipType: json['MemberShipType']?.toString(),
      amount: (json['Amount'] as num?)?.toDouble(),
      discount: (json['Discount'] as num?)?.toDouble(),
      refNo: json['RefNo']?.toString(),
    );
  }
}
