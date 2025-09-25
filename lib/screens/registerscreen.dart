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

                            /// Full Name
                            _buildLabel("Full Name"),
                            _buildTextField(
                              hint: "Enter your full name",
                              icon: Icons.person,
                            ),

                            /// Home Club
                            _buildLabel("Home Club"),
                            _buildTextField(
                              hint: "Enter your home club",
                              icon: Icons.sports_golf,
                            ),

                            /// Email
                            _buildLabel("Email"),
                            TextField(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email_outlined),
                                border: const OutlineInputBorder(),
                                hintText: "Enter your email",
                                suffixIcon: TextButton(
                                  onPressed: () {
                                    // TODO: Add email verification logic
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

                            /// Phone Number
                            _buildLabel("Phone Number"),
                            _buildTextField(
                              hint: "Enter your phone number",
                              icon: Icons.phone,
                              keyboard: TextInputType.phone,
                            ),

                            /// Age
                            _buildLabel("Age"),
                            _buildTextField(
                              hint: "Enter your age",
                              icon: Icons.calendar_today,
                              keyboard: TextInputType.number,
                            ),

                            /// DOB
                            _buildLabel("Date of Birth"),
                            _buildTextField(
                              hint: "DD/MM/YYYY",
                              icon: Icons.date_range,
                            ),

                            /// USGA Handicap Index
                            _buildLabel("USGA Handicap (Index)"),
                            _buildTextField(
                              hint: "Enter your handicap index",
                              icon: Icons.score,
                              keyboard: TextInputType.number,
                            ),

                            /// GHIN Number
                            _buildLabel("GHIN No"),
                            _buildTextField(
                              hint: "Enter your GHIN number",
                              icon: Icons.confirmation_number,
                            ),

                            /// Password
                            _buildLabel("Password"),
                            _buildTextField(
                              hint: "Enter your password",
                              icon: Icons.lock_outline,
                              obscure: true,
                            ),

                            /// Confirm Password
                            _buildLabel("Confirm Password"),
                            _buildTextField(
                              hint: "Re-enter your password",
                              icon: Icons.lock_reset,
                              obscure: true,
                            ),

                            const SizedBox(height: 20),

                            /// Register Button
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
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CustomBottomNav(),
                                    ),
                                    (route) => false,
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

  /// Helper: Label
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Helper: TextField
  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      obscureText: obscure,
      keyboardType: keyboard,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        hintText: hint,
      ),
    );
  }
}
