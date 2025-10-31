import 'package:delhi_golf_federation/bloc/razorpay_success/bloc/razorpay_success_event.dart';
import 'package:delhi_golf_federation/bloc/razorpay_success/bloc/razorpay_success_state.dart';
import 'package:delhi_golf_federation/data/razorpay_success_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class PaymentAfterSuccessBloc
    extends Bloc<PaymentAfterSuccessEvent, PaymentAfterSuccessState> {
  final PaymentAfterSuccess repo;

  PaymentAfterSuccessBloc(this.repo) : super(PaymentInitial()) {
    on<FetchPaymentAfterSuccess>(_onFetchPaymentDetails);
  }

  Future<void> _onFetchPaymentDetails(
    FetchPaymentAfterSuccess event,
    Emitter<PaymentAfterSuccessState> emit,
  ) async {
    emit(PaymentLoading());
    try {
      final details = await repo.getPaymentDetails(
        paymentId: event.paymentId,
        key: event.key,
        secret: event.secret,
      );
      emit(PaymentLoaded(details));
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }
}
