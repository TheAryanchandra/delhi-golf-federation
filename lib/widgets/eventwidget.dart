import 'dart:convert';
import 'package:delhi_golf_federation/bloc/eventregister/bloc/eventregister_bloc.dart';
import 'package:delhi_golf_federation/bloc/eventregister/bloc/eventregister_event.dart';
import 'package:delhi_golf_federation/bloc/eventregister/bloc/eventregister_state.dart';
import 'package:delhi_golf_federation/bloc/getdata/bloc/getdata_bloc.dart';
import 'package:delhi_golf_federation/bloc/getdata/bloc/getdata_state.dart';
import 'package:delhi_golf_federation/components/color_constants.dart';
import 'package:delhi_golf_federation/data/paymentrepository.dart';
import 'package:delhi_golf_federation/data/razorpay_success_repository.dart';
import 'package:delhi_golf_federation/model/eventregistermodel.dart';
import 'package:delhi_golf_federation/model/getdatamodel.dart';
import 'package:delhi_golf_federation/model/paymentmodel.dart';
import 'package:delhi_golf_federation/services/TextFieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class EventRegisterPopup extends StatefulWidget {
  final String eventRefNo;
  final double? price;
  final String? paymentMode;

  const EventRegisterPopup({
    super.key,
    required this.eventRefNo,
    this.price,
    this.paymentMode,
  });

  @override
  State<EventRegisterPopup> createState() => _EventRegisterPopupState();
}

class _EventRegisterPopupState extends State<EventRegisterPopup> {
  final _formKey = GlobalKey<FormState>();
  final Razorpay _razorpay = Razorpay();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _clubController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _handicapController = TextEditingController();
  final TextEditingController _ghinController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isProgressVisible = false;
  bool _prefilled = false;

  String? _selectedGender;
  final List<String> _genderOptions = ["Male", "Female", "Other"];

  PaymentData? _paymentData;

  @override
  void initState() {
    super.initState();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  // ✅ Razorpay Success
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    debugPrint("✅ [Razorpay] Payment Success:");
    debugPrint("🔹 Payment ID: ${response.paymentId}");
    debugPrint("🔹 Order ID: ${response.orderId}");

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Payment Successful: ${response.paymentId}")),
    );

    try {
      // ✅ Fetch Razorpay payment details
      final paymentAfterSuccess = PaymentAfterSuccess();

      if (_paymentData?.key == null || _paymentData?.secret == null) {
        debugPrint("⚠️ Missing Razorpay key/secret — skipping fetch");
        return;
      }

      final razorpayDetails = await paymentAfterSuccess.getPaymentDetails(
        paymentId: response.paymentId!,
        key: _paymentData!.key!,
        secret: _paymentData!.secret!,
      );

      debugPrint(
        "💳 Razorpay Details: ${jsonEncode(razorpayDetails.toJson())}",
      );

      // ✅ Prepare confirmation request for backend
      final updatedPayment = PaymentRequest(
        id: 0,
        eventRefNo: widget.eventRefNo,
        rzrPaymentId: response.paymentId ?? '',
        rzrTransactionId: razorpayDetails.acquirerData?.upiTransactionId ?? '',
        currency: razorpayDetails.currency ?? "INR",
        method: razorpayDetails.method ?? '',
        cardId: '',
        international: razorpayDetails.international ?? false,
        paymentStatus: 'SUCCESS',
        rzrSignature: response.signature ?? '',
        rzrOrderId: response.orderId ?? '',
        amount: widget.price ?? 0.0,
        cmpCode: '',
        userId: '',
        roleId: null,
        formType: 'EventRegister',
        source: 'APP',
        dataJson: jsonEncode(razorpayDetails.toJson()),
        contactNo: razorpayDetails.contact ?? '',
        bank: razorpayDetails.bank ?? '',
        wallet: razorpayDetails.wallet ?? '',
        email: razorpayDetails.email ?? '',
        dts: DateTime.now().toIso8601String(),
        name: _nameController.text,
      );

      debugPrint("📤 Confirming payment to backend...");
      final paymentRepo = PaymentRepository();
      final apiResponse = await paymentRepo.confirmPayment(
        request: updatedPayment,
        cmpCode: updatedPayment.cmpCode ?? '',
      );

      debugPrint("✅ Payment confirmed on backend: ${jsonEncode(apiResponse)}");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("🎉 Registration completed successfully!"),
          ),
        );
        Navigator.of(context, rootNavigator: true).pop();
      }
    } catch (e, stack) {
      debugPrint("❌ Error confirming payment: $e");
      debugPrint("📜 $stack");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Payment Failed: ${response.message}")),
      );
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("🌐 External Wallet: ${response.walletName}")),
      );
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _fillForm(UserDataModel userData) {
    _nameController.text = userData.name;
    _clubController.text = userData.homeClub;
    _emailController.text = userData.email;
    _phoneController.text = userData.phoneNumber;
    _dobController.text = userData.dob;
    _handicapController.text = userData.usgaHandicapIndex.toString();
    _ghinController.text = userData.ghinNo;
    _passwordController.text = userData.password;
    _selectedGender = _genderOptions.contains(userData.gender)
        ? userData.gender
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataBloc, UserDataState>(
      builder: (context, state) {
        if (state is UserDataLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserDataError) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(state.message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          );
        } else if (state is UserDataLoaded && !_prefilled) {
          _fillForm(state.userData);
          _prefilled = true;
        }

        return BlocListener<EventRegistrationBloc, EventRegistrationState>(
          listener: (context, state) async {
            if (state is EventRegistrationLoading) {
              _isProgressVisible = true;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );
            } else if (_isProgressVisible) {
              Navigator.of(context, rootNavigator: true).pop();
              _isProgressVisible = false;
            }

            if (state is EventRegistrationSuccess) {
              final response = state.response;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("✅ ${response.message ?? ''}")),
              );

              // ✅ Handle UPI (no payment gateway)
              if (widget.paymentMode?.toLowerCase() == "upi") {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("✅ UPI registration completed successfully!"),
                  ),
                );
                Navigator.of(context, rootNavigator: true).pop();
                return;
              }

              // ✅ Razorpay flow
              if (response.response?.payment != null) {
                final payment = response.response!.payment!;
                final user = response.response!.userData!;

                _paymentData = payment;

                if (payment.key == null ||
                    payment.key!.isEmpty ||
                    payment.orderId == null ||
                    payment.orderId!.isEmpty) {
                  debugPrint(
                    "⚠️ Missing Razorpay key or orderId, aborting checkout.",
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Payment key/order missing, please try again.",
                      ),
                    ),
                  );
                  return;
                }

                _openRazorpayCheckout(
                  payment.key!,
                  payment.orderId!,
                  widget.price ?? 0.0,
                  user.userName ?? "DGFI User",
                  user.emailId ?? "",
                  user.mobileNo ?? "",
                );
              }
            } else if (state is EventRegistrationFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("❌ ${state.error}")));
            }
          },
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 40,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        "REGISTER",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.buttonColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    GlobalTextField(
                      controller: _nameController,
                      prefixIcon: Icons.person,
                      enabled: false,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Required field" : null,
                    ),
                    GlobalTextField(
                      controller: _emailController,
                      prefixIcon: Icons.email_outlined,
                      enabled: false,
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<EventRegistrationBloc, EventRegistrationState>(
                      builder: (context, state) {
                        final isLoading = state is EventRegistrationLoading;
                        return ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    final userDataState = context
                                        .read<UserDataBloc>()
                                        .state;
                                    if (userDataState is UserDataLoaded) {
                                      final userData = userDataState.userData;

                                      final request = EventRegistrationRequest(
                                        id: 0,
                                        email: userData.email,
                                        homeClub: _clubController.text.trim(),
                                        usgaHandicapIndex:
                                            double.tryParse(
                                              _handicapController.text.trim(),
                                            ) ??
                                            0.0,
                                        ghinNo: _ghinController.text.trim(),
                                        userId: userData.email,
                                        cmpCode: userData.cmpCode,
                                        roleId: null,
                                        refNo: "",
                                        activateStatus: "",
                                        source: "APP",
                                        eventRefNo: widget.eventRefNo,
                                        amount: widget.price ?? 0.0,
                                        paymentMode:
                                            widget.paymentMode ?? "online",
                                        status: "",
                                      );

                                      debugPrint(
                                        "🟢 Sending Payload: ${jsonEncode(request.toJson())}",
                                      );
                                      context.read<EventRegistrationBloc>().add(
                                        SubmitEventRegistration(request),
                                      );
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorConstants.buttonColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Submit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _openRazorpayCheckout(
    String key,
    String orderId,
    double amount,
    String userName,
    String email,
    String contact,
  ) {
    debugPrint("🧾 Razorpay Checkout -------------------");
    debugPrint("Key: $key | Order ID: $orderId | Amount: $amount");

    if (key.isEmpty) {
      debugPrint("❌ Razorpay key missing — cannot proceed");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment key missing, please try again.")),
      );
      return;
    }

    var options = {
      'key': key,
      'amount': (amount * 100).toInt(),
      'name': userName,
      'order_id': orderId,
      'prefill': {'contact': contact, 'email': email},
      'theme': {'color': '#0F5C4C'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("❌ Razorpay Checkout Error: $e");
    }
  }

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime(2000),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: ColorConstants.buttonColor,
              ),
            ),
            child: child!,
          ),
        );
        if (pickedDate != null) {
          setState(() {
            _dobController.text =
                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
          });
        }
      },
      child: AbsorbPointer(
        child: GlobalTextField(
          controller: _dobController,
          prefixIcon: Icons.calendar_today_outlined,
          validator: (v) =>
              v == null || v.isEmpty ? "Please select your DOB" : null,
        ),
      ),
    );
  }
}
