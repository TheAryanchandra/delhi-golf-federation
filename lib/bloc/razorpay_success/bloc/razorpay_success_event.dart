import 'package:equatable/equatable.dart';

abstract class PaymentAfterSuccessEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPaymentAfterSuccess extends PaymentAfterSuccessEvent {
  final String paymentId;
  final String key;
  final String secret;

  FetchPaymentAfterSuccess({
    required this.paymentId,
    required this.key,
    required this.secret,
  });

  @override
  List<Object?> get props => [paymentId, key, secret];
}
