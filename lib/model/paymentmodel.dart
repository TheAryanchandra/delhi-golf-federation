class PaymentRequest {
  int? id;
  String? eventRefNo;
  String? rzrPaymentId;
  String? rzrTransactionId;
  String? currency;
  String? method;
  String? cardId;
  bool? international;
  String? paymentStatus;
  String? rzrSignature;
  String? rzrOrderId;
  double? amount;
  String? cmpCode;
  String? userId;
  int? roleId;
  String? formType;
  String? source;
  String? dataJson;
  String? contactNo;
  String? bank;
  String? wallet;
  String? email;
  String? dts;
  String? name;

  PaymentRequest({
    this.id,
    this.eventRefNo,
    this.rzrPaymentId,
    this.rzrTransactionId,
    this.currency,
    this.method,
    this.cardId,
    this.international,
    this.paymentStatus,
    this.rzrSignature,
    this.rzrOrderId,
    this.amount,
    this.cmpCode,
    this.userId,
    this.roleId,
    this.formType,
    this.source,
    this.dataJson,
    this.contactNo,
    this.bank,
    this.wallet,
    this.email,
    this.dts,
    this.name,
  });

  Map<String, dynamic> toJson() => {
        "Id": id,
        "EventRefNo": eventRefNo,
        "rzr_PaymentId": rzrPaymentId,
        "rzr_TransactionId": rzrTransactionId,
        "Currency": currency,
        "Method": method,
        "CardId": cardId,
        "International": international,
        "PaymentStatus": paymentStatus,
        "rzr_signature": rzrSignature,
        "rzr_orderId": rzrOrderId,
        "Amount": amount,
        "Cmp_Code": cmpCode,
        "UserId": userId,
        "RoleId": roleId,
        "FormType": formType,
        "Source": source,
        "DataJSON": dataJson,
        "ContactNo": contactNo,
        "Bank": bank,
        "wallet": wallet,
        "Email": email,
        "DTS": dts,
        "Name": name,
      };
}

class PaymentResponse {
  int? id;
  int? bigId;
  bool? status;
  String? message;
  String? refNo;
  PaymentResponseData? response;
  List<dynamic>? dataList;
  dynamic ds;
  dynamic dt;

  PaymentResponse({
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

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      id: json["Id"],
      bigId: json["BigId"],
      status: json["status"],
      message: json["message"],
      refNo: json["RefNo"],
      response: json["response"] != null
          ? PaymentResponseData.fromJson(json["response"])
          : null,
      dataList: json["DataList"],
      ds: json["_ds"],
      dt: json["_dt"],
    );
  }
}

class PaymentResponseData {
  PaymentDetails? payment;
  PaymentKeys? paymentKey;

  PaymentResponseData({this.payment, this.paymentKey});

  factory PaymentResponseData.fromJson(Map<String, dynamic> json) {
    return PaymentResponseData(
      payment:
          json["payment"] != null ? PaymentDetails.fromJson(json["payment"]) : null,
      paymentKey:
          json["PaymentKey"] != null ? PaymentKeys.fromJson(json["PaymentKey"]) : null,
    );
  }
}

class PaymentDetails {
  int? id;
  String? eventRefNo;
  String? rzrPaymentId;
  String? rzrTransactionId;
  String? currency;
  String? method;
  String? cardId;
  bool? international;
  String? paymentStatus;
  String? rzrSignature;
  String? rzrOrderId;
  double? amount;
  String? cmpCode;
  String? userId;
  int? roleId;
  String? formType;
  String? source;
  String? dataJson;
  String? contactNo;
  String? bank;
  String? wallet;
  String? email;
  String? dts;
  String? name;

  PaymentDetails({
    this.id,
    this.eventRefNo,
    this.rzrPaymentId,
    this.rzrTransactionId,
    this.currency,
    this.method,
    this.cardId,
    this.international,
    this.paymentStatus,
    this.rzrSignature,
    this.rzrOrderId,
    this.amount,
    this.cmpCode,
    this.userId,
    this.roleId,
    this.formType,
    this.source,
    this.dataJson,
    this.contactNo,
    this.bank,
    this.wallet,
    this.email,
    this.dts,
    this.name,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      id: json["Id"],
      eventRefNo: json["EventRefNo"],
      rzrPaymentId: json["rzr_PaymentId"],
      rzrTransactionId: json["rzr_TransactionId"],
      currency: json["Currency"],
      method: json["Method"],
      cardId: json["CardId"],
      international: json["International"],
      paymentStatus: json["PaymentStatus"],
      rzrSignature: json["rzr_signature"],
      rzrOrderId: json["rzr_orderId"],
      amount: (json["Amount"] != null)
          ? double.tryParse(json["Amount"].toString())
          : null,
      cmpCode: json["Cmp_Code"],
      userId: json["UserId"],
      roleId: json["RoleId"],
      formType: json["FormType"],
      source: json["Source"],
      dataJson: json["DataJSON"],
      contactNo: json["ContactNo"],
      bank: json["Bank"],
      wallet: json["wallet"],
      email: json["Email"],
      dts: json["DTS"],
      name: json["Name"],
    );
  }
}

class PaymentKeys {
  String? key;
  String? secret;

  PaymentKeys({this.key, this.secret});

  factory PaymentKeys.fromJson(Map<String, dynamic> json) {
    return PaymentKeys(
      key: json["Key"],
      secret: json["Secret"],
    );
  }
}
