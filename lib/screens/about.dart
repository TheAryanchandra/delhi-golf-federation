import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Banner Header with Image + Overlay + Title
            // ✅ Banner Header (like Leaderboard)
ClipRRect(
  borderRadius: const BorderRadius.only(
    bottomLeft: Radius.circular(20),
    bottomRight: Radius.circular(20),
  ),
  child: Stack(
    alignment: Alignment.center,
    children: [
      Image.asset(
        "assets/images/welcome.png", // same banner image
        height: 140, // same as leaderboard
        width: double.infinity,
        fit: BoxFit.cover,
      ),
      Container(
        height: 140,
        width: double.infinity,
        color: Colors.black.withOpacity(0.4),
      ),
      const Text(
        "About Us",
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    ],
  ),
),


            const SizedBox(height: 20),

            /// Introduction Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Introduction to DGF",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B592A),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "The Delhi Golf Federation (DGF) is the official body promoting and developing golf across Delhi under the aegis of the Delhi Olympic Association. Our mission is to make golf accessible to every citizen — from school students and amateur players to seasoned professionals — and to position Delhi as a hub for golfing excellence in India.\n\n"
                    "Our vision is to democratize golf, breaking the notion of golf being an elite sport, and to integrate it into the wider sporting culture of the city, in line with India’s aspirations for the Olympics 2036.",
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// History Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        "assets/images/golf.png",
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "History",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0B592A),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Founded with the belief that golf should be available to all Delhiites, DGF has worked to create pathways for participation at every level. From grassroots school initiatives to hosting tournaments that prepare athletes for national and international platforms, DGF has become the driving force behind golf’s expansion in Delhi.\n\n"
                          "Key milestones include:\n- Launch of the First Delhi Golf Festival 2025 at Qutab Golf Course.\n- Establishing golf development programs for students and youth.\n- Recognition under the Delhi Olympic Association.",
                          style: TextStyle(fontSize: 14, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Values Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Values",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0B592A),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "At the heart of our work are the values of:\n\n"
                          "• Accessibility – Opening golf to all sections of society.\n"
                          "• Excellence – Nurturing players to reach national and international levels.\n"
                          "• Inclusivity – Encouraging diversity across age, gender, and backgrounds.\n"
                          "• Integrity – Promoting fair play, discipline, and sportsmanship.",
                          style: TextStyle(fontSize: 14, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        "assets/images/sitting area.png",
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
