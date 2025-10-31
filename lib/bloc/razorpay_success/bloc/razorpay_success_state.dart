import 'package:delhi_golf_federation/model/razorpayresponse_model.dart';
import 'package:equatable/equatable.dart';


abstract class PaymentAfterSuccessState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentAfterSuccessState {}

class PaymentLoading extends PaymentAfterSuccessState {}

class PaymentLoaded extends PaymentAfterSuccessState {
  final RazorpayPaymentDetails paymentDetails;

  PaymentLoaded(this.paymentDetails);

  @override
  List<Object?> get props => [paymentDetails];
}

class PaymentError extends PaymentAfterSuccessState {
  final String message;

  PaymentError(this.message);

  @override
  List<Object?> get props => [message];
}
