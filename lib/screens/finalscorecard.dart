import 'package:delhi_golf_federation/components/custombutton.dart';
import 'package:delhi_golf_federation/components/bottomnavigation.dart';
import 'package:flutter/material.dart';

class ConfirmUploadScoreScreen extends StatelessWidget {
  final List<Map<String, dynamic>> holes;
  const ConfirmUploadScoreScreen({super.key, required this.holes});

  int get totalScore => holes.fold(0, (sum, hole) => sum + (hole["score"] as int));
  int get totalPar => holes.fold(0, (sum, hole) => sum + (hole["par"] as int));

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF12563C);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: mainColor),
        title: const Text(
          "Confirm & Upload Score",
          style: TextStyle(
            color: mainColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🏆 Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: mainColor.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: const [
                  Text(
                    "Delhi Golf Championship 2025",
                    style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Confirm your entered scores before uploading",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 📋 Final Score Table
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: mainColor.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  // Table Header
                  Container(
                    decoration: const BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text("Hole",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text("Par",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text("Index",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text("Score",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Table Body
                  ...holes.map((hole) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade300,
                            width: 0.8,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Center(
                                  child: Text("${hole['hole']}",
                                      style: const TextStyle(fontSize: 15)))),
                          Expanded(
                              child: Center(
                                  child: Text("${hole['par']}",
                                      style: const TextStyle(fontSize: 15)))),
                          Expanded(
                              child: Center(
                                  child: Text("${hole['index']}",
                                      style: const TextStyle(fontSize: 15)))),
                          Expanded(
                              child: Center(
                                  child: Text(
                            "${hole['score']}",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: mainColor,
                            ),
                          ))),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🧮 Totals
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: mainColor.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Par:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    totalPar.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    "Total Score:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    totalScore.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ☁️ Upload Button
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: "Upload Score",
                backgroundColor: mainColor,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: const Text(
                        "Confirm Upload",
                        style: TextStyle(
                            color: mainColor, fontWeight: FontWeight.bold),
                      ),
                      content: const Text(
                        "Are you sure you want to upload your scorecard?",
                        style: TextStyle(color: Colors.black87),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Score uploaded successfully!"),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CustomBottomNav(initialIndex: 3),
                              ),
                              (route) => false,
                            );
                          },
                          child: const Text(
                            "Upload",
                            style: TextStyle(
                              color: Colors.white, // ✅ White text on green button
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
