# TODO: Fix Payment Errors in Event Widget

## Tasks
- [ ] Update PaymentData class in lib/model/eventregistermodel.dart to include all required fields (id, eventRefNo, currency, method, international, rzrOrderId, amount, cmpCode, userId, roleId, formType, source, contactNo, bank, wallet, email, name) and fix typo in ResponseData.fromJson ('paymemt' to 'payment').
- [ ] Fix PaymentRequest creation in lib/widgets/eventwidget.dart _handleRazorpaySuccess: set rzrTransactionId to response.paymentId, remove externalWallet, use custom map for dataJson.
- [ ] Add updatePayment method to PaymentRepository in lib/data/paymentrepository.dart as alias to confirmPayment.

## Followup Steps
- [ ] Test the payment flow after fixes.
