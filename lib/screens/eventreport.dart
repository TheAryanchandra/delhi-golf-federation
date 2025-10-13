import 'package:delhi_golf_federation/components/color_constants.dart';
import 'package:delhi_golf_federation/screens/eventscorecard.dart';
import 'package:flutter/material.dart';
import 'package:delhi_golf_federation/components/custombutton.dart';
// import 'package:delhi_golf_federation/screens/leaderboard_screen.dart';

class EventReportScreen extends StatefulWidget {
  const EventReportScreen({super.key});

  @override
  State<EventReportScreen> createState() => _EventReportScreenState();
}

class _EventReportScreenState extends State<EventReportScreen> {
  bool showCurrent = true;

  void _switchTab(bool current) {
    setState(() {
      showCurrent = current;
    });
  }

  final List<Map<String, String>> currentEvents = [
    {
      "eventname": "Delhi Open 2025",
      "eventdate": "11 Oct 25 - 14 Oct 25",
      "registration": "01 Oct 25 - 05 Oct 25",
      "venue": "Delhi Golf Course New Delhi",
      "prize": "₹5,00,000",
    },
  ];

  final List<Map<String, String>> pastEvents = [
    {
      "eventname": "Gurgaon Invitational 2024",
      "eventdate": "10 Sep 24 - 12 Sep 24",
      "registration": "01 Sep 24 - 05 Sep 24",
      "venue": "Classic Golf Resort Gurgaon",
      "prize": "₹3,00,000",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Image
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
                  color: Colors.black.withOpacity(0.35),
                ),
                const Text(
                  "Scorecards",
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

          // Custom Toggle Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: "Current Scorecards",
                    onPressed: () => _switchTab(true),
                    backgroundColor:
                        showCurrent ? const Color(0xFF0B592A) : Colors.white,
                    textColor:
                        showCurrent ? Colors.white : const Color(0xFF0B592A),
                    borderRadius: 12,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: "Past Scorecards",
                    onPressed: () => _switchTab(false),
                    backgroundColor:
                        !showCurrent ? const Color(0xFF0B592A) : Colors.white,
                    textColor:
                        !showCurrent ? Colors.white : const Color(0xFF0B592A),
                    borderRadius: 12,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
          ),

          // Event List
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: ListView.builder(
                itemCount:
                    showCurrent ? currentEvents.length : pastEvents.length,
                itemBuilder: (context, index) {
                  final event =
                      showCurrent ? currentEvents[index] : pastEvents[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            event["eventname"]!,
                            style: const TextStyle(
                              color: Color(0xFF12563C),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                color: Color(0xFF12563C), size: 18),
                            const SizedBox(width: 8),
                            Text(
                              "Event: ${event["eventdate"]}",
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.event_available,
                                color: Color(0xFF12563C), size: 18),
                            const SizedBox(width: 8),
                            Text(
                              "Registration: ${event["registration"]}",
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Color(0xFF12563C), size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                event["venue"]!,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.attach_money,
                                color: Color(0xFF12563C), size: 18),
                            const SizedBox(width: 8),
                            Text(
                              "Prize Money: ${event["prize"]!}",
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // ✅ Buttons Section
                        Row(
                          children: [
                            if (showCurrent) ...[
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const EventScorecardScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        ColorConstants.buttonColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                  ),
                                  child: const Text(
                                    "Add Score",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const EventScorecardScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        ColorConstants.buttonColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                  ),
                                  child: const Text(
                                    "Update Score",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // TODO: Replace with your leaderboard screen
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => const LeaderboardScreen(),
                                    //   ),
                                    // );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        ColorConstants.buttonColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                  ),
                                  child: const Text(
                                    "Leaderboard",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
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
