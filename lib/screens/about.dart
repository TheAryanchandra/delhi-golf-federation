import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ✅ Banner Header
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
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: 160,
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.45),
                  ),
                  const Text(
                    "About Us",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ✅ Introduction Section
            _buildSectionCard(
              title: "Introduction to DGF",
              titleColor: const Color(0xFF0B592A),
              content:
                  "The Delhi Golf Federation (DGF) is the official body promoting and developing golf across Delhi under the aegis of the Delhi Olympic Association. Our mission is to make golf accessible to every citizen — from school students and amateur players to seasoned professionals — and to position Delhi as a hub for golfing excellence in India.\n\n"
                  "Our vision is to democratize golf, breaking the notion of golf being an elite sport, and to integrate it into the wider sporting culture of the city, in line with India’s aspirations for the Olympics 2036.",
            ),

            const SizedBox(height: 20),

            /// ✅ History Section
            _buildImageTextSection(
              title: "History",
              titleColor: const Color(0xFF12563C), // requested color
              content:
                  "Founded with the belief that golf should be available to all Delhiites, DGF has worked to create pathways for participation at every level. From grassroots school initiatives to hosting tournaments that prepare athletes for national and international platforms, DGF has become the driving force behind golf’s expansion in Delhi.\n\n"
                  "Key milestones include:\n- Launch of the First Delhi Golf Festival 2025 at Qutab Golf Course.\n- Establishing golf development programs for students and youth.\n- Recognition under the Delhi Olympic Association.",
              image: "assets/images/golf.png",
              imageLeft: true,
            ),

            const SizedBox(height: 20),

            /// ✅ Values Section
            _buildImageTextSection(
              title: "Values",
              titleColor: const Color(0xFF0B592A),
              content:
                  "At the heart of our work are the values of:\n\n"
                  "• Accessibility – Opening golf to all sections of society.\n"
                  "• Excellence – Nurturing players to reach national and international levels.\n"
                  "• Inclusivity – Encouraging diversity across age, gender, and backgrounds.\n"
                  "• Integrity – Promoting fair play, discipline, and sportsmanship.",
              image: "assets/images/sitting area.png",
              imageLeft: false,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// 🔹 Reusable Card Section
  Widget _buildSectionCard({
    required String title,
    required String content,
    required Color titleColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Reusable Image + Text Section
  Widget _buildImageTextSection({
    required String title,
    required String content,
    required String image,
    required Color titleColor,
    bool imageLeft = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageLeft) _buildImage(image),
          if (imageLeft) const SizedBox(width: 14),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
          if (!imageLeft) const SizedBox(width: 14),
          if (!imageLeft) _buildImage(image),
        ],
      ),
    );
  }

  /// 🔹 Reusable Image Box
  Widget _buildImage(String path) {
    return Expanded(
      flex: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          path,
          height: 160,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
