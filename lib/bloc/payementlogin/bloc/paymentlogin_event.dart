import 'package:delhi_golf_federation/model/paymentmodel.dart';
import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreatePaymentEvent extends PaymentEvent {
  final PaymentRequest paymentRequest;
  final String cmpCode;

  CreatePaymentEvent({required this.paymentRequest, required this.cmpCode});

  @override
  List<Object?> get props => [paymentRequest, cmpCode];
}

class ConfirmPaymentEvent extends PaymentEvent {
  final PaymentRequest paymentRequest;
  final String cmpCode;

  ConfirmPaymentEvent({required this.paymentRequest, required this.cmpCode});

  @override
  List<Object?> get props => [paymentRequest, cmpCode];
}
