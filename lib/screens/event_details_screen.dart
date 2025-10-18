import 'package:flutter/material.dart';
import '../components/color_constants.dart';
import '../model/eventmodel.dart';

class EventDetailsScreen extends StatelessWidget {
  final EventModel event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final mainColor = ColorConstants.buttonColor;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: mainColor,
        centerTitle: true,
        title: const Text(
          'Event Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Banner
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1508873699372-7aeab60b44a7?auto=format&fit=crop&w=900&q=60',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.all(16),
                child: Text(
                  event.eventName ?? 'Event Name',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Event Info Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow("Event Date", "${event.startDate ?? ''} - ${event.endDate ?? ''}", mainColor),
                    const Divider(),
                    _buildInfoRow("Venue", event.venue ?? 'No Venue', mainColor),
                    const Divider(),
                    _buildInfoRow("Category", "Amateur", mainColor),
                    const Divider(),
                    _buildInfoRow("Format", "Stroke Play", mainColor),
                    const Divider(),
                    _buildInfoRow("Organizer", "Delhi Golf Federation", mainColor),
                    if (event.priceMoney != null) ...[
                      const Divider(),
                      _buildInfoRow("Prize Money", event.priceMoney!, mainColor),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Description
            const Text(
              "About the Event",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorConstants.buttonColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "The Delhi Golf Federation Cup is one of the most prestigious tournaments "
              "in the region, bringing together top amateur players for an exciting competition. "
              "Join us for a weekend of skill, sportsmanship, and spectacular golf.",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade800,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            // Register Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: const Icon(Icons.app_registration, color: Colors.white),
                label: const Text(
                  "Register Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, Color mainColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: mainColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
