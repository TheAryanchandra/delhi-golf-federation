import 'dart:convert';
import 'package:delhi_golf_federation/bloc/eventregister/bloc/eventregister_bloc.dart';
import 'package:delhi_golf_federation/bloc/eventregister/bloc/eventregister_event.dart';
import 'package:delhi_golf_federation/bloc/eventregister/bloc/eventregister_state.dart';
import 'package:delhi_golf_federation/bloc/getdata/bloc/getdata_bloc.dart';
import 'package:delhi_golf_federation/bloc/getdata/bloc/getdata_state.dart';
import 'package:delhi_golf_federation/components/color_constants.dart';
import 'package:delhi_golf_federation/model/eventregistermodel.dart';
import 'package:delhi_golf_federation/model/getdatamodel.dart';
import 'package:delhi_golf_federation/model/industrymodel.dart';
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
  String? _selectedIndustry;
  final List<String> _genderOptions = ["Male", "Female", "Other"];

  @override
  void initState() {
    super.initState();
    // context.read<IndustryBloc>().add(FetchIndustriesEvent());

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Payment Successful: ${response.paymentId}")),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ Payment Failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("🌐 External Wallet: ${response.walletName}")),
    );
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
    _selectedIndustry = userData.industryRefNo;
  }

  int _calculateAge(String dob) {
    try {
      final parts = dob.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        final birthDate = DateTime(year, month, day);
        final today = DateTime.now();
        int age = today.year - birthDate.year;
        if (today.month < birthDate.month ||
            (today.month == birthDate.month && today.day < birthDate.day)) {
          age--;
        }
        return age;
      }
    } catch (_) {}
    return 0;
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
        } else if (state is UserDataLoaded) {
          if (!_prefilled) {
            _fillForm(state.userData);
            _prefilled = true;
          }
        }

        return BlocListener<EventRegistrationBloc, EventRegistrationState>(
          listener: (context, state) {
            if (state is EventRegistrationLoading) {
              _isProgressVisible = true;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );
            } else {
              if (_isProgressVisible) {
                final nav = Navigator.of(context, rootNavigator: true);
                if (nav.canPop()) nav.pop();
                _isProgressVisible = false;
              }
            }

            if (state is EventRegistrationSuccess) {
              final response = state.response;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("✅ ${response.message ?? ''}")),
              );

              final navigator = Navigator.of(context, rootNavigator: true);
              navigator.pop();

              // 🧾 Handle payment
              if (widget.paymentMode?.toLowerCase() == "upi") {
                // Direct registration (no gateway)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("✅ UPI registration completed successfully"),
                  ),
                );
              } else if (response.response?.payment != null) {
                // Razorpay flow
                final payment = response.response!.payment!;
                final user = response.response!.userData!;

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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("❌ ${state.error}")),
              );
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
              child: Padding(
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
                        validator: (v) =>
                            v == null || v.isEmpty ? "Required field" : null,
                      ),
                      GlobalTextField(
                        controller: _clubController,
                        prefixIcon: Icons.groups_3_outlined,
                        validator: (v) =>
                            v == null || v.isEmpty ? "Required field" : null,
                      ),
                      GlobalTextField(
                        controller: _emailController,
                        prefixIcon: Icons.email_outlined,
                        enabled: false,
                      ),
                      GlobalTextField(
                        controller: _phoneController,
                        prefixIcon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: (v) =>
                            v == null || v.isEmpty ? "Required field" : null,
                      ),

                      _buildDatePicker(context),
                      const SizedBox(height: 20),

                      BlocBuilder<EventRegistrationBloc,
                          EventRegistrationState>(
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

                                        final request =
                                            EventRegistrationRequest(
                                          id: 0,
                                          email: userData.email,
                                          homeClub:
                                              _clubController.text.trim(),
                                          usgaHandicapIndex: double.tryParse(
                                                  _handicapController.text
                                                      .trim()) ??
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

                                        print("🟢 Sending Payload: ${jsonEncode(request.toJson())}");

                                        context
                                            .read<EventRegistrationBloc>()
                                            .add(SubmitEventRegistration(request));
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstants.buttonColor,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
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
  debugPrint("🧾 Razorpay Checkout Triggered -------------------");
  debugPrint("🔹 Key: $key");
  debugPrint("🔹 Order ID: $orderId");
  debugPrint("🔹 Amount: $amount");
  debugPrint("🔹 Name: $userName");
  debugPrint("🔹 Email: $email");
  debugPrint("🔹 Contact: $contact");
  debugPrint("-----------------------------------------------");

  var options = {
    'key': key,
    'amount': (amount * 100).toInt(), // Razorpay expects paise
    'name': userName,
    'order_id': orderId,
    'prefill': {'contact': contact, 'email': email},
    'theme': {'color': '#0F5C4C'},
  };

  try {
    _razorpay.open(options);
    debugPrint("✅ Razorpay Checkout Opened Successfully");
  } catch (e, stackTrace) {
    debugPrint("❌ Razorpay Checkout Error: $e");
    debugPrint("📜 StackTrace: $stackTrace");
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
              colorScheme:
                  ColorScheme.light(primary: ColorConstants.buttonColor),
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
