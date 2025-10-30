import 'package:delhi_golf_federation/components/color_constants.dart';
import 'package:delhi_golf_federation/config/routes_name.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({Key? key}) : super(key: key);

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  String selectedPlan = 'Gold';

  final Map<String, dynamic> membershipData = {
    'Gold': {'price': 5000, 'discount': 500},
    'Premium': {'price': 10000, 'discount': 1500},
  };

  @override
  Widget build(BuildContext context) {
    final price = membershipData[selectedPlan]!['price'] as int;
    final discount = membershipData[selectedPlan]!['discount'] as int;
    final payable = price - discount;

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

                // Stylish Plan Selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPlanOption('Gold'),
                    _buildPlanOption('Premium'),
                  ],
                ),

                const SizedBox(height: 25),

                // Membership Details Section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    border: Border.all(color: Colors.white30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildRow('Amount', '₹$price'),
                      _buildRow('Discount', '₹$discount'),
                      _buildRow('Payable Amount', '₹$payable'),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                // Proceed Button
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
                    _showConfirmDialog(context, selectedPlan, payable);
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

  /// Builds the plan option with visible circular selection
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
                  color:
                      isSelected ? ColorConstants.buttonColor : Colors.white,
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

  void _showConfirmDialog(BuildContext context, String plan, int payable) {
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '$plan membership activated successfully for ₹$payable!',
                  ),
                  backgroundColor: ColorConstants.buttonColor,
                ),
              );
            },
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
