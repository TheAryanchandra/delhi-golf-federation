import 'package:flutter/material.dart';
import 'package:delhi_golf_federation/components/topnavigationbar.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final List<Map<String, String>> videos = [
      {
        "thumbnail": "assets/images/classic golf country.png",
        "title": "Tiger Woods Golf",
      },
      {
        "thumbnail": "assets/images/Silver partner.png",
        "title": "Great Putting Drill",
      },
      {
        "thumbnail": "assets/images/classic golf country.png",
        "title": "Tiger Woods Golf",
      },
      {
        "thumbnail": "assets/images/Silver partner.png",
        "title": "Great Putting Drill",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEFF2F1),
      // appBar: const TopNavigationBar(showBackButton: true),
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
                  "Videos",
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
            "Video",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  childAspectRatio: 0.65,
                ),
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Image.asset(
                          video["thumbnail"]!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        Container(
                          color: Colors.black54,
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            video["title"]!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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
