import 'package:flutter/material.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final List<String> galleryImages = [
      "assets/images/classic golf country.png",
      "assets/images/Silver partner.png",
      "assets/images/welcome.png", // add more images as needed
      "assets/images/classic golf country.png",
      "assets/images/Silver partner.png",
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEFF2F1),
      body: Column(
        children: [
          // Header
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
                  "Gallery",
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

          const SizedBox(height: 12),

          const Text(
            "Gallery",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: galleryImages.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      galleryImages[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
