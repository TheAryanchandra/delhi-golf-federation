import 'package:delhi_golf_federation/model/paymentmodel.dart';
import 'package:equatable/equatable.dart';

abstract class PaymentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final PaymentResponse response;

  PaymentSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class PaymentConfirmed extends PaymentState {
  final PaymentResponse response;

  PaymentConfirmed(this.response);

  @override
  List<Object?> get props => [response];
}

class PaymentFailure extends PaymentState {
  final String error;

  PaymentFailure(this.error);

  @override
  List<Object?> get props => [error];
}
