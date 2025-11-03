import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../components/color_constants.dart';
import '../config/routes_name.dart'; // ensure EventScreen route is defined here

class PaymentDoneScreen extends StatelessWidget {
  const PaymentDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🎉 Lottie success animation
                Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    color: ColorConstants.buttonColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Lottie.asset(
                    'assets/animations/Success.json',
                    height: 180,
                    repeat: false,
                  ),
                ),

                const SizedBox(height: 30),

                // 🎯 Title
                Text(
                  "Payment Successful!",
                  style: TextStyle(
                    color: ColorConstants.buttonColor,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // 💬 Subtitle
                Text(
                  "Your payment has been completed successfully.\nThank you for your registration!",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // 🚀 Continue button → Go to EventScreen
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      // Navigator.pushNamedAndRemoveUntil(
                      //   context,
                      //   RoutesName.eventScreen, // ✅ Go to EventScreen
                      //   (route) => false,
                      // );
                    },
                    child: const Text(
                      "Go to Events",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
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
}
