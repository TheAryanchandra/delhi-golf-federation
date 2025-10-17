import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventScoreViewScreen extends StatefulWidget {
  const EventScoreViewScreen({super.key});

  @override
  State<EventScoreViewScreen> createState() => _EventScoreViewScreenState();
}

class _EventScoreViewScreenState extends State<EventScoreViewScreen> {
  static const mainColor = Color(0xFF12563C);

  DateTime? selectedDate;

  Map<String, dynamic> get sampleApiResponse => {
        "response": {
          "_dt": [
            {
              "Dates": "2025-10-17T00:00:00",
              "EventName": "DLF GOLF",
              "Hole_Thru": 1,
              "Par": 4,
              "Indexs": 1,
              "Points": -3,
            },
            {
              "Dates": "2025-10-17T00:00:00",
              "EventName": "DLF GOLF",
              "Hole_Thru": 2,
              "Par": 3,
              "Indexs": 11,
              "Points": -2,
            },
            {
              "Dates": "2025-10-18T00:00:00",
              "EventName": "DLF GOLF",
              "Hole_Thru": 3,
              "Par": 4,
              "Indexs": 7,
              "Points": 2,
            },
            {
              "Dates": "2025-10-18T00:00:00",
              "EventName": "DLF GOLF",
              "Hole_Thru": 4,
              "Par": 3,
              "Indexs": 8,
              "Points": 0,
            },
          ]
        }
      };

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final allData = List<Map<String, dynamic>>.from(
      sampleApiResponse["response"]["_dt"] ?? [],
    );

    // Sort by hole
    allData.sort((a, b) => (a["Hole_Thru"] ?? 0).compareTo(b["Hole_Thru"] ?? 0));

    // Filter data based on selected date
    final filteredData = allData.where((hole) {
      try {
        final holeDate = DateTime.parse(hole["Dates"]);
        return DateFormat('yyyy-MM-dd').format(holeDate) ==
            DateFormat('yyyy-MM-dd').format(selectedDate!);
      } catch (_) {
        return false;
      }
    }).toList();

    final eventName =
        filteredData.isNotEmpty ? filteredData.first["EventName"] : "Event Scorecard";

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: mainColor,
        centerTitle: true,
        title: Text(
          eventName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // 🔹 Date Selector
          Container(
            color: mainColor.withOpacity(0.1),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Selected Date:",
                  style: TextStyle(
                    color: mainColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month, color: Colors.white, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          DateFormat('dd MMM yyyy').format(selectedDate!),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Score Card Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Header Row
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: mainColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text("Hole",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, color: mainColor))),
                            Expanded(
                                child: Text("Par",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, color: mainColor))),
                            Expanded(
                                child: Text("Index",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, color: mainColor))),
                            Expanded(
                                child: Text("Points",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, color: mainColor))),
                            Expanded(
                                child: Text("Date",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, color: mainColor))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Data List
                      Expanded(
                        child: filteredData.isEmpty
                            ? const Center(
                                child: Text(
                                  "No scores available for this date",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : ListView.separated(
                                itemCount: filteredData.length,
                                separatorBuilder: (_, __) =>
                                    Divider(color: Colors.grey.shade300),
                                itemBuilder: (context, index) {
                                  final hole = filteredData[index];
                                  final formattedDate = DateFormat('dd/MM/yyyy')
                                      .format(DateTime.parse(hole["Dates"]));
                                  final points = hole["Points"] ?? 0;

                                  Color pointsColor;
                                  if (points < 0) {
                                    pointsColor = Colors.redAccent;
                                  } else if (points > 0) {
                                    pointsColor = Colors.green.shade700;
                                  } else {
                                    pointsColor = Colors.orangeAccent;
                                  }

                                  return Container(
                                    decoration: BoxDecoration(
                                      color: index.isEven
                                          ? Colors.grey.shade100
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text("${hole["Hole_Thru"]}",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(color: mainColor))),
                                        Expanded(
                                            child: Text("${hole["Par"]}",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(color: mainColor))),
                                        Expanded(
                                            child: Text("${hole["Indexs"]}",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(color: mainColor))),
                                        Expanded(
                                          child: Text(
                                            "$points",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: pointsColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            child: Text(formattedDate,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(color: mainColor))),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
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
