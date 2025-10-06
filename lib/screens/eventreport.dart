import 'package:delhi_golf_federation/components/color_constants.dart';
import 'package:delhi_golf_federation/screens/eventscorecard.dart';
import 'package:flutter/material.dart';

class EventReportScreen extends StatelessWidget {
  const EventReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Dummy data for events
    final List<Map<String, String>> events = [
      {
        "sr": "1",
        "eventTime": "06 Oct 2025, 10:00 AM",
        "courseName": "Pebble Beach Golf Links",
      },
      {
        "sr": "2",
        "eventTime": "07 Oct 2025, 02:00 PM",
        "courseName": "Augusta National Golf Club",
      },
      {
        "sr": "3",
        "eventTime": "08 Oct 2025, 09:30 AM",
        "courseName": "St. Andrews Old Course",
      },
    ];

    return Scaffold(
      body: Column(
        children: [
          // Custom header with image and text
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

          // Event Table
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Scrollbar(
                thumbVisibility: true, // Always show horizontal scrollbar
                trackVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Scrollbar(
                    thumbVisibility: true, // Always show vertical scrollbar
                    trackVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(
                          Colors.green.shade100,
                        ),
                        border: TableBorder.all(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        columns: const [
                          DataColumn(label: Text("Sr.No")),
                          DataColumn(label: Text("Event Time")),
                          DataColumn(label: Text("Course Name")),
                          DataColumn(label: Text("Action")),
                        ],
                        rows: events.map((event) {
                          return DataRow(
                            cells: [
                              DataCell(Text(event["sr"]!)),
                              DataCell(Text(event["eventTime"]!)),
                              DataCell(Text(event["courseName"]!)),
                              DataCell(
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorConstants.buttonColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const EventScorecardScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Add Score",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
