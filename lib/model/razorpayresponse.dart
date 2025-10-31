class RazorpayPaymentDetails {
  String? id;
  String? status;
  String? method;
  String? currency;
  String? orderId;
  String? description;
  double? amount;
  String? email;
  String? contact;
  String? vpa;
  String? bank;
  String? wallet;

  RazorpayPaymentDetails({
    this.id,
    this.status,
    this.method,
    this.currency,
    this.orderId,
    this.description,
    this.amount,
    this.email,
    this.contact,
    this.vpa,
    this.bank,
    this.wallet,
  });

  factory RazorpayPaymentDetails.fromJson(Map<String, dynamic> json) {
    return RazorpayPaymentDetails(
      id: json["id"],
      status: json["status"],
      method: json["method"],
      currency: json["currency"],
      orderId: json["order_id"],
      description: json["description"],
      amount: (json["amount"] ?? 0) / 100, // Razorpay returns amount in paise
      email: json["email"],
      contact: json["contact"],
      vpa: json["vpa"],
      bank: json["bank"],
      wallet: json["wallet"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "status": status,
      "method": method,
      "currency": currency,
      "order_id": orderId,
      "description": description,
      "amount": amount != null
          ? (amount! * 100).toInt()
          : null, // Convert back to paise if needed
      "email": email,
      "contact": contact,
      "vpa": vpa,
      "bank": bank,
      "wallet": wallet,
    };
  }
}
