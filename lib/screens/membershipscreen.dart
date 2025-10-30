import 'package:delhi_golf_federation/components/color_constants.dart';
import 'package:delhi_golf_federation/config/routes_name.dart';
import 'package:delhi_golf_federation/model/paymentmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../main.dart';
import '../model/login_model.dart';

import '../bloc/payementlogin/bloc/paymentlogin_bloc.dart';
import '../bloc/payementlogin/bloc/paymentlogin_event.dart';

class MembershipScreen extends StatefulWidget {
  final LoginResponse? loginResponse;
  const MembershipScreen({Key? key, this.loginResponse}) : super(key: key);

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  String selectedPlan = '';

  @override
  void initState() {
    super.initState();
    if (widget.loginResponse != null &&
        widget.loginResponse!.membershipPlans != null &&
        widget.loginResponse!.membershipPlans!.isNotEmpty) {
      selectedPlan =
          widget.loginResponse!.membershipPlans!.first.membershipType ?? 'Gold';
      print('User Name: ${widget.loginResponse!.response?.userName}');
      print('Email: ${widget.loginResponse!.response?.emailId}');
      print('Mobile: ${widget.loginResponse!.response?.mobileNo}');
      print('Cmp Code: ${widget.loginResponse!.response?.cmpCode}');
      print('Membership Plans: ${widget.loginResponse!.membershipPlans}');
    } else {
      selectedPlan = 'Gold';
    }
  }

  Map<String, dynamic> get membershipData {
    return {
      for (var plan in widget.loginResponse!.membershipPlans!)
        plan.membershipType ?? 'Unknown': {
          'price': plan.amount ?? 0,
          'discount': plan.discount ?? 0,
          'refNo': plan.refNo,
        },
    };
  }

  @override
  Widget build(BuildContext context) {
    final price = membershipData[selectedPlan]!['price'] as double;
    final discount = membershipData[selectedPlan]!['discount'] as double;
    final payable = price - (price * discount / 100);

    return WillPopScope(
      onWillPop: () async {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          RoutesName.loginScreen,
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.grey.withOpacity(0.2),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorConstants.buttonColor),
            onPressed: () {
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                RoutesName.loginScreen,
                (route) => false,
              );
            },
          ),
          iconTheme: IconThemeData(color: ColorConstants.buttonColor),
          title: Text(
            'Membership Plans',
            style: TextStyle(
              color: ColorConstants.buttonColor,
              fontWeight: FontWeight.w700,
              fontSize: 20,
              letterSpacing: 0.5,
            ),
          ),
        ),
        body: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(28),
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: ColorConstants.buttonColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Choose Your Plan',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: membershipData.keys
                      .map((plan) => _buildPlanOption(plan))
                      .toList(),
                ),
                const SizedBox(height: 25),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    border: Border.all(color: Colors.white30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildRow('Amount', '₹$price'),
                      _buildRow('Discount', '%$discount'),
                      _buildRow('Payable Amount', '₹$payable'),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.25),
                  ),
                  onPressed: () {
                    final selectedPlanData = membershipData[selectedPlan];
                    final String? eventRefNo = selectedPlanData['refNo'];
                    final String cmpCode =
                        widget.loginResponse?.response?.cmpCode ?? '';

                    if (eventRefNo == null || cmpCode.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Missing payment details.'),
                        ),
                      );
                      return;
                    }

                    _showConfirmDialog(
                        context, selectedPlan, payable, cmpCode, eventRefNo);
                  },
                  child: Text(
                    'Proceed to Pay',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.buttonColor,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanOption(String plan) {
    final bool isSelected = selectedPlan == plan;
    return GestureDetector(
      onTap: () => setState(() => selectedPlan = plan),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.2),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? ColorConstants.buttonColor : Colors.white,
                  width: 2.5,
                ),
                color: isSelected
                    ? ColorConstants.buttonColor
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Text(
              plan,
              style: TextStyle(
                color: isSelected
                    ? ColorConstants.buttonColor
                    : Colors.white.withOpacity(0.9),
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(BuildContext context, String plan, double payable,
      String cmpCode, String eventRefNo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Confirm Membership',
          style: TextStyle(
            color: ColorConstants.buttonColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: Text(
          'You are about to purchase the $plan membership for ₹$payable.\nDo you wish to continue?',
          style: TextStyle(color: Colors.grey[800], fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstants.buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              _handlePayment(context, cmpCode, eventRefNo, payable);
            },
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _handlePayment(
      BuildContext context, String cmpCode, String eventRefNo, double amount) {
    final paymentRequest = PaymentRequest(
      id: 0,
      eventRefNo: eventRefNo,
      rzrPaymentId: '',
      rzrTransactionId: '',
      currency: 'INR',
      method: 'Online',
      cardId: '',
      international: false,
      paymentStatus: 'Pending',
      rzrSignature: '',
      rzrOrderId: '',
      amount: amount,
      cmpCode: cmpCode,
      userId:  '',
      roleId: 1,
      formType: 'Membership',
      source: 'APP',
      dataJson: '',
      contactNo: widget.loginResponse?.response?.mobileNo ?? '',
      bank: '',
      wallet: '',
      email: widget.loginResponse?.response?.emailId ?? '',
      dts: DateTime.now().toIso8601String(),
      name: widget.loginResponse?.response?.userName ?? '',
    );

    context.read<PaymentBloc>().add(
          CreatePaymentEvent(
            paymentRequest: paymentRequest,
            cmpCode: cmpCode,
          ),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Processing payment for ₹$amount...'),
        backgroundColor: ColorConstants.buttonColor,
      ),
    );
  }
}
