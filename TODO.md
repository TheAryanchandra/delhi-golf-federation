# TODO: Fix PaymentAfterSuccess() to work properly

## Steps to Complete:
- [x] Update _handleRazorpaySuccess in lib/screens/membershipscreen.dart to use PaymentRepository().confirmPayment directly after fetching Razorpay details, and handle response with UI feedback.
- [x] Remove ConfirmPaymentEvent from lib/bloc/payementlogin/bloc/paymentlogin_event.dart.
- [x] Remove PaymentConfirmed from lib/bloc/payementlogin/bloc/paymentlogin_state.dart.
- [x] Remove _onConfirmPayment from lib/bloc/payementlogin/bloc/paymentlogin_bloc.dart.
- [x] Update BlocListener in lib/screens/membershipscreen.dart to remove PaymentConfirmed case.
