import 'package:delhi_golf_federation/components/custombutton.dart';
import 'package:flutter/material.dart';
import 'package:delhi_golf_federation/components/topnavigationbar.dart';


class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  int selectedTab = 0; // 0 = Latest News, 1 = Past News

  final List<Map<String, String>> newsItems = [
    {
      "time": "19 Hours",
      "title": "Ryder Cup boys’ club?: Golf Channel Podcast",
    },
    {
      "time": "23 Hours",
      "title": "Golf is Hard | Wind Edition | 2025",
    },
    {
      "time": "12 Hours",
      "title": "He gained how many yards in one offseason? #golf",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFEFF2F1),
      body: Column(
        children: [
          // Header with ClipRRect
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
                  height: screenHeight * 0.18,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: screenHeight * 0.18,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.4),
                ),
                const Text(
                  "News",
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

          const SizedBox(height: 16),

          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildTabs(),
          ),

          const SizedBox(height: 16),

          // News list
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildNewsList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          _buildTabButton("Latest News", 0),
          _buildTabButton("Past News", 1),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final bool isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF12563C) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewsList() {
    if (selectedTab == 0) {
      // Latest News → Coming Soon placeholders
      return ListView.separated(
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Coming Soon...",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                CustomButton(
                  text: "View more",
                  onPressed: () {},
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  borderRadius: 12,
                ),
              ],
            ),
          );
        },
      );
    } else {
      // Past News → show actual news items
      return ListView.separated(
        itemCount: newsItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = newsItems[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${item['time']} Ago",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['title']!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomButton(
                  text: "View more",
                  onPressed: () {},
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  borderRadius: 12,
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
