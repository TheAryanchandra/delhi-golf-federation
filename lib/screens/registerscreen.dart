import 'package:flutter/material.dart';
import '../components/bottomnavigation.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// Background Image
          Image.asset("assets/images/background.png", fit: BoxFit.cover),

          /// Overlay
          Container(color: Colors.black.withOpacity(0.3)),

          /// Main Content
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 120),

                  /// Card with Logo Overlap
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      /// Register Card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 60), // Space for Logo

                            const Center(
                              child: Text(
                                "REGISTER",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),

                            /// Name field
                            const Text(
                              "Full Name",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person),
                                border: const OutlineInputBorder(),
                                hintText: "Enter your full name",
                              ),
                            ),
                            const SizedBox(height: 20),

                            
                            /// Email field
                            const Text(
                              "Email",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email_outlined),
                                border: const OutlineInputBorder(),
                                hintText: "Enter your email",
                                suffixIcon: TextButton(
                                  onPressed: () {
                                    // TODO: Add email verification logic here (API call / OTP etc.)
                                    print("Verifying email...");
                                  },
                                  child: const Text(
                                    "Verify",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            const SizedBox(height: 8),
                            TextField(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email_outlined),
                                border: const OutlineInputBorder(),
                                hintText: "Enter your email",
                              ),
                            ),
                            const SizedBox(height: 20),

                            /// Password field
                            const Text(
                              "Password",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_outline),
                                border: const OutlineInputBorder(),
                                hintText: "Enter your password",
                              ),
                            ),
                            const SizedBox(height: 20),

                            /// Confirm Password field
                            const Text(
                              "Confirm Password",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_reset),
                                border: const OutlineInputBorder(),
                                hintText: "Re-enter your password",
                              ),
                            ),
                            const SizedBox(height: 20),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0B592A),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CustomBottomNav(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Register",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 15),

                            /// Already have an account
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Back to Login
                                },
                                child: const Text(
                                  "Already have an account? Login",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Positioned Logo Overlapping
                      Positioned(
                        top: -50,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.white,
                            backgroundImage: const AssetImage(
                              "assets/images/logo.png",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
