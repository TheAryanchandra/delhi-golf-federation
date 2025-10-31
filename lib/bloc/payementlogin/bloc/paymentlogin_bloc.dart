import 'package:delhi_golf_federation/bloc/payementlogin/bloc/paymentlogin_event.dart';
import 'package:delhi_golf_federation/bloc/payementlogin/bloc/paymentlogin_state.dart';
import 'package:delhi_golf_federation/data/paymentrepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository repository;

  PaymentBloc(this.repository) : super(PaymentInitial()) {
    on<CreatePaymentEvent>(_onCreatePayment);
    on<ConfirmPaymentEvent>(_onConfirmPayment);
  }

  Future<void> _onCreatePayment(
    CreatePaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    try {
      final response = await repository.createPayment(
        request: event.paymentRequest,
        cmpCode: event.cmpCode,
      );
      emit(PaymentSuccess(response));
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }

  Future<void> _onConfirmPayment(
    ConfirmPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    try {
      final response = await repository.confirmPayment(
        request: event.paymentRequest,
        cmpCode: event.cmpCode,
      );
      emit(PaymentConfirmed(response));
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }
}
