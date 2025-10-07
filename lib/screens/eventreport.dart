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
        "eventname": "Delhi Open 2025",
        "eventdate": "06 Oct 2025 - 08 Oct 2025",
      },
      {
        "sr": "2",
        "eventname": "Banglore Open 2025",
        "eventdate": "10 Oct 2025 - 12 Oct 2025",
      },
      {
        "sr": "3",
        "eventname": "Gurgoan Open 2025",
        "eventdate": "15 Oct 2025 - 17 Oct 2025",
      },
    ];

    return Scaffold(
      body: Column(
        children: [
          // Header with background image + title
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
                thumbVisibility: true,
                trackVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Scrollbar(
                    thumbVisibility: true,
                    trackVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(
                          const Color(0xFF12563C), // your theme color
                        ),
                        headingTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        border: TableBorder.all(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        columns: const [
                          DataColumn(label: Text("Sr.No")),
                          DataColumn(label: Text("Event Name")),
                          DataColumn(label: Text("Event Date")),
                          DataColumn(label: Text("Action")),
                        ],
                        rows: events.map((event) {
                          return DataRow(
                            cells: [
                              DataCell(Text(event["sr"]!)),
                              DataCell(Text(event["eventname"]!)),
                              DataCell(Text(event["eventdate"]!)),
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
