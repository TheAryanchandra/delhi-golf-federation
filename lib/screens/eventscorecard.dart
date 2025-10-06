import 'package:delhi_golf_federation/components/color_constants.dart';
import 'package:delhi_golf_federation/components/custombutton.dart';
import 'package:delhi_golf_federation/screens/eventreport.dart';
import 'package:flutter/material.dart';


class EventScorecardScreen extends StatefulWidget {
  const EventScorecardScreen({super.key});

  @override
  State<EventScorecardScreen> createState() => _EventScorecardScreenState();
}

class _EventScorecardScreenState extends State<EventScorecardScreen> {
  final List<Map<String, dynamic>> holes = [
    {"hole": 1, "par": 4, "index": 10, "score": 0},
    {"hole": 2, "par": 3, "index": 15, "score": 0},
    {"hole": 3, "par": 5, "index": 5, "score": 0},
    {"hole": 4, "par": 4, "index": 9, "score": 0},
    {"hole": 5, "par": 4, "index": 3, "score": 0},
    {"hole": 6, "par": 3, "index": 12, "score": 0},
    {"hole": 7, "par": 5, "index": 1, "score": 0},
    {"hole": 8, "par": 4, "index": 7, "score": 0},
    {"hole": 9, "par": 4, "index": 18, "score": 0},
  ];

  int get totalScore =>
      holes.fold(0, (sum, hole) => sum + (hole["score"] as int));

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        // title: const Text(
        //   "Event Scorecard",
        //   style: TextStyle(fontWeight: FontWeight.bold),
        // ),
        backgroundColor: const Color.fromARGB(255, 248, 250, 249),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ClipRRect header below AppBar
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
                  "Event Scorecard",
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

          // Event Score Table
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
                          ColorConstants.buttonColor.withOpacity(0.2),
                        ),
                        dataRowColor: MaterialStateProperty.all(
                          Colors.green.shade50,
                        ),
                        border: TableBorder.all(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        columns: const [
                          DataColumn(label: Text("Hole")),
                          DataColumn(label: Text("Par")),
                          DataColumn(label: Text("Index")),
                          DataColumn(label: Text("Score")),
                          DataColumn(label: Text("Total")),
                        ],
                        rows: holes.map((hole) {
                          return DataRow(
                            cells: [
                              DataCell(Text(hole["hole"].toString())),
                              DataCell(Text(hole["par"].toString())),
                              DataCell(Text(hole["index"].toString())),
                              DataCell(
                                SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    initialValue: hole["score"].toString(),
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        hole["score"] = int.tryParse(val) ?? 0;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  hole["score"].toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
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

          const SizedBox(height: 16),

          // Total Score Section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: ColorConstants.buttonColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Score:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  totalScore.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.buttonColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: "Save Score",
              backgroundColor: ColorConstants.buttonColor,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
