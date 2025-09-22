import 'package:delhi_golf_federation/components/custombutton.dart';
import 'package:flutter/material.dart';


class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  bool showUpcoming = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// Banner Header (Image + Text)
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
                  height: screenHeight * 0.15,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: screenHeight * 0.15,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.35),
                ),
                const Text(
                  "Events",
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

          /// Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: "Upcoming Events",
                    onPressed: () => setState(() => showUpcoming = true),
                    backgroundColor:
                        showUpcoming ? const Color(0xFF0B592A) : Colors.white,
                    textColor:
                        showUpcoming ? Colors.white : const Color(0xFF0B592A),
                    borderRadius: 12,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: "Past Events",
                    onPressed: () => setState(() => showUpcoming = false),
                    backgroundColor:
                        !showUpcoming ? const Color(0xFF0B592A) : Colors.white,
                    textColor:
                        !showUpcoming ? Colors.white : const Color(0xFF0B592A),
                    borderRadius: 12,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// Content
          Expanded(
            child: showUpcoming
                ? const Center(
                    child: Text(
                      "Coming Soon",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildEventCard(
                        "12 - 14",
                        "Aug 2025",
                        "Golf Championship",
                        "Delhi Golf Course",
                      ),
                      _buildEventCard(
                        "05 - 07",
                        "September 2025",
                        "Spring Invitational",
                        "Quba Golf Course",
                      ),
                      _buildEventCard(
                        "10 - 12",
                        "October 2025",
                        "Winter Cup",
                        "Noida Golf Course",
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  /// Event Card Widget
  Widget _buildEventCard(
      String date, String monthYear, String title, String location) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Date Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  monthYear,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          /// Info Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: Color(0xFF0B592A),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        location,
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          /// View More Button
          CustomButton(
            text: "View More",
            onPressed: () {},
            borderRadius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ],
      ),
    );
  }
}
