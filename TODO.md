# TODO for Updating eventwidget.dart to use PaymentData from eventregister model

- [ ] Add PaymentData? _paymentData; field to _EventRegisterPopupState class.
- [ ] In BlocListener for EventRegistrationSuccess, set _paymentData = state.response.response?.payment;
- [ ] In _handlePaymentSuccess, replace hardcoded key with _paymentData?.key ?? '' and secret with _paymentData?.secret ?? ''
