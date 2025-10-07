import 'package:delhi_golf_federation/components/color_constants.dart';
import 'package:delhi_golf_federation/components/custombutton.dart';
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
    const mainColor = Color(0xFF12563C);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: mainColor),
        title: const Text(
          "Event Scorecard",
          style: TextStyle(
            color: mainColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        trackVisibility: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Event Info Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: mainColor, width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Event: Delhi Golf Championship 2025",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Player: Aryan Chandra",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Handicap: 12",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Score Table Vertical Layout
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: mainColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: mainColor.withOpacity(0.4)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Hole-wise Details",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Dynamic Hole Cards
                      ...holes.map((hole) {
                        bool highlightHole =
                            hole["hole"] == 1 || hole["hole"] == 1;

                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: mainColor.withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Hole Info
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Hole number with black dot
                                  Row(
                                    children: [
                                      if (highlightHole)
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black,
                                          ),
                                        ),
                                      if (highlightHole)
                                        const SizedBox(width: 6),
                                      Text(
                                        "Hole ${hole["hole"]}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: mainColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  // Par with circled hole number
                                  
                                  // Par with hole number as superscript on top-right
                                  Row(
                                    children: [
                                      Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Text(
                                            "Par: ${hole["par"]}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          if (highlightHole)
                                            Positioned(
                                              right:
                                                  -10, // adjust horizontal position
                                              top:
                                                  -6, // adjust vertical position
                                              child: Text(
                                                hole["hole"].toString(),
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: mainColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  Text("Index: ${hole["index"]}"),
                                ],
                              ),

                              // Score Input Box
                              SizedBox(
                                width: 70,
                                child: TextFormField(
                                  initialValue: hole["score"].toString(),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Score",
                                    labelStyle: const TextStyle(
                                      fontSize: 12,
                                      color: mainColor,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: mainColor,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      hole["score"] = int.tryParse(val) ?? 0;
                                    });
                                  },
                                ),
                              ),

                              // Total per Hole
                              Text(
                                hole["score"].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: mainColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Total Score Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: mainColor, width: 1.2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Score:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      totalScore.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Save Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: "Save Score",
                    backgroundColor: mainColor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
