class RazorpayPaymentDetails {
  String? id;
  String? entity;
  double? amount; // In Rupees
  String? currency;
  String? status;
  String? orderId;
  String? invoiceId;
  bool? international;
  String? method;
  double? amountRefunded;
  String? refundStatus;
  bool? captured;
  String? description;
  String? cardId;
  String? bank;
  String? wallet;
  String? vpa;
  String? email;
  String? contact;
  List<dynamic>? notes;
  double? fee;
  double? tax;
  String? errorCode;
  String? errorDescription;
  String? errorSource;
  String? errorStep;
  String? errorReason;
  AcquirerData? acquirerData;
  int? createdAt;
  UpiData? upi;

  RazorpayPaymentDetails({
    this.id,
    this.entity,
    this.amount,
    this.currency,
    this.status,
    this.orderId,
    this.invoiceId,
    this.international,
    this.method,
    this.amountRefunded,
    this.refundStatus,
    this.captured,
    this.description,
    this.cardId,
    this.bank,
    this.wallet,
    this.vpa,
    this.email,
    this.contact,
    this.notes,
    this.fee,
    this.tax,
    this.errorCode,
    this.errorDescription,
    this.errorSource,
    this.errorStep,
    this.errorReason,
    this.acquirerData,
    this.createdAt,
    this.upi,
  });

  factory RazorpayPaymentDetails.fromJson(Map<String, dynamic> json) {
    return RazorpayPaymentDetails(
      id: json['id'],
      entity: json['entity'],
      amount: (json['amount'] != null) ? json['amount'] / 100.0 : null,
      currency: json['currency'],
      status: json['status'],
      orderId: json['order_id'],
      invoiceId: json['invoice_id'],
      international: json['international'],
      method: json['method'],
      amountRefunded: (json['amount_refunded'] != null)
          ? json['amount_refunded'] / 100.0
          : null,
      refundStatus: json['refund_status'],
      captured: json['captured'],
      description: json['description'],
      cardId: json['card_id'],
      bank: json['bank'],
      wallet: json['wallet'],
      vpa: json['vpa'],
      email: json['email'],
      contact: json['contact'],
      notes: json['notes'],
      fee: (json['fee'] != null) ? json['fee'] / 100.0 : null,
      tax: (json['tax'] != null) ? json['tax'] / 100.0 : null,
      errorCode: json['error_code'],
      errorDescription: json['error_description'],
      errorSource: json['error_source'],
      errorStep: json['error_step'],
      errorReason: json['error_reason'],
      acquirerData: json['acquirer_data'] != null
          ? AcquirerData.fromJson(json['acquirer_data'])
          : null,
      createdAt: json['created_at'],
      upi: json['upi'] != null ? UpiData.fromJson(json['upi']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entity': entity,
      'amount': amount != null ? (amount! * 100).toInt() : null,
      'currency': currency,
      'status': status,
      'order_id': orderId,
      'invoice_id': invoiceId,
      'international': international,
      'method': method,
      'amount_refunded':
          amountRefunded != null ? (amountRefunded! * 100).toInt() : null,
      'refund_status': refundStatus,
      'captured': captured,
      'description': description,
      'card_id': cardId,
      'bank': bank,
      'wallet': wallet,
      'vpa': vpa,
      'email': email,
      'contact': contact,
      'notes': notes,
      'fee': fee != null ? (fee! * 100).toInt() : null,
      'tax': tax != null ? (tax! * 100).toInt() : null,
      'error_code': errorCode,
      'error_description': errorDescription,
      'error_source': errorSource,
      'error_step': errorStep,
      'error_reason': errorReason,
      'acquirer_data': acquirerData?.toJson(),
      'created_at': createdAt,
      'upi': upi?.toJson(),
    };
  }
}

class AcquirerData {
  String? rrn;                 // For UPI reference number
  String? upiTransactionId;    // For UPI transaction ID
  String? bankTransactionId;   // For Netbanking transaction ID
  String? authCode;            // For Card authorization code

  AcquirerData({
    this.rrn,
    this.upiTransactionId,
    this.bankTransactionId,
    this.authCode,
  });

  factory AcquirerData.fromJson(Map<String, dynamic> json) {
    return AcquirerData(
      rrn: json['rrn'],
      upiTransactionId: json['upi_transaction_id'],
      bankTransactionId: json['bank_transaction_id'],
      authCode: json['auth_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rrn': rrn,
      'upi_transaction_id': upiTransactionId,
      'bank_transaction_id': bankTransactionId,
      'auth_code': authCode,
    };
  }
}


class UpiData {
  String? vpa;
  String? flow;

  UpiData({this.vpa, this.flow});

  factory UpiData.fromJson(Map<String, dynamic> json) {
    return UpiData(
      vpa: json['vpa'],
      flow: json['flow'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vpa': vpa,
      'flow': flow,
    };
  }
}
