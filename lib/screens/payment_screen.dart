import 'package:flutter/material.dart';
import 'package:delhi_golf_federation/services/navigation_service.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFEFF2F1),
      body: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "assets/images/welcome.png",
                  height: screenHeight * 0.125,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: screenHeight * 0.125,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.4),
                ),
                const Text(
                  "Qutab Golf Course - DDA",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildPaymentSummaryCard(),
                    const SizedBox(height: 16),
                    _buildTeeSelection(),
                    const SizedBox(height: 16),
                    _buildPlayersSection(),
                    const SizedBox(height: 16),
                    _buildAdditionalDetail(),
                    const SizedBox(height: 12),
                    _buildChargesAndTotal(),
                    const SizedBox(height: 12),
                    _buildTermsAndConditions(),
                    const SizedBox(height: 16),
                    _buildPayNowButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Payment Summary",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                "3.33",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            "Pay & Play",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Date", style: TextStyle(fontWeight: FontWeight.w500)),
              Text("19/02/2025 (Fri)"),
            ],
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Time", style: TextStyle(fontWeight: FontWeight.w500)),
              Text("7:00 AM"),
            ],
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Base Fee", style: TextStyle(fontWeight: FontWeight.w500)),
              Text("1980rs"),
            ],
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Saving", style: TextStyle(fontWeight: FontWeight.w500)),
              Text("0%"),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ Tee Selection
  Widget _buildTeeSelection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Tee 1", style: TextStyle(fontWeight: FontWeight.bold)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "18 Holes",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayersSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Players",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          _buildPlayerRow("Rishab Gaur", "Rs 1980", "0%", "Rs 1980"),
          _buildPlayerRow("Rishab Gaur", "Rs 1980", "0%", "Rs 1980"),
          _buildPlayerRow("Rishab Gaur", "Rs 1980", "0%", "Rs 1980"),
        ],
      ),
    );
  }

  Widget _buildPlayerRow(
      String name, String price, String savings, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 2, child: Text(name)),
          Expanded(flex: 1, child: Text(price)),
          Expanded(flex: 1, child: Text(savings)),
          Expanded(flex: 1, child: Text(amount, textAlign: TextAlign.end)),
        ],
      ),
    );
  }

  Widget _buildAdditionalDetail() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Additional Detail",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          _buildDetailRow(Icons.electric_car_outlined, "Cart", "0"),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.accessibility_new, "Caddy", "0"),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label),
        ]),
        Text(value),
      ],
    );
  }

  Widget _buildChargesAndTotal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Service Charges (2.5%)",
                style: TextStyle(color: Colors.grey, fontSize: 13)),
            Text("Rs. 148.5"),
          ],
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total Payable",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Text("Rs 6089",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 15)),
          ],
        ),
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      children: [
        Checkbox(
          value: termsAccepted,
          onChanged: (value) {
            setState(() => termsAccepted = value ?? false);
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        Expanded(
          child: RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 13),
              children: [
                TextSpan(text: "I have read and accept the "),
                TextSpan(
                  text: "terms and conditions",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ✅ Custom Button used here
  Widget _buildPayNowButton() {
    return CustomButton(
      text: "PAY NOW",
      onPressed: termsAccepted 
        ? () {
            // Navigate to homepage when payment is successful
            NavigationService.instance.navigateToHomepage();
          } 
        : () {
            // Show message if terms not accepted
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please accept the terms and conditions'),
                backgroundColor: Colors.red,
              ),
            );
          },
      backgroundColor: const Color(0xFF12563C),
      borderRadius: 12,
      padding: const EdgeInsets.symmetric(vertical: 14),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}

// ✅ Reusable Custom Button
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(0xFF0B592A),
    this.textColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
