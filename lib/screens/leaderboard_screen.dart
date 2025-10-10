import 'package:flutter/material.dart';

class ColorConstants {
  static const Color green = Color(0xFF12563C);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color darkGray = Color(0xFF333333);
  static const Color redAccent = Colors.red;
}

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final List<Map<String, dynamic>> leaderboardData = [
    {"pos": "01", "state": "🇮🇳", "name": "Player One", "today": "-5", "hole": "13", "score": "-17", "r1": "62", "r2": "72", "r3": "63", "r4": "61", "gross": "258", "net": "04"},
    {"pos": "02", "state": "🇮🇳", "name": "Player Two", "today": "-4", "hole": "13", "score": "-15", "r1": "67", "r2": "65", "r3": "71", "r4": "62", "gross": "265", "net": "04"},
    {"pos": "03", "state": "🇮🇳", "name": "Player Three", "today": "+2", "hole": "13", "score": "-13", "r1": "68", "r2": "62", "r3": "64", "r4": "77", "gross": "271", "net": "04"},
    {"pos": "04", "state": "🇮🇳", "name": "Player Four", "today": "+6", "hole": "13", "score": "-12", "r1": "72", "r2": "66", "r3": "61", "r4": "65", "gross": "264", "net": "04"},
    {"pos": "05", "state": "🇮🇳", "name": "Player Five", "today": "-8", "hole": "13", "score": "-10", "r1": "65", "r2": "73", "r3": "66", "r4": "69", "gross": "273", "net": "04"},
  ];

  // Add a ScrollController
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose controller to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.emoji_events, color: ColorConstants.green, size: 28),
                SizedBox(width: 10),
                Text(
                  "LEADERBOARD",
                  style: TextStyle(
                    color: ColorConstants.green,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Material(
                    elevation: 4,
                    shadowColor: Colors.black26,
                    child: Scrollbar(
                      controller: _scrollController, // attach controller here
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: _scrollController, // attach controller here
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(ColorConstants.green),
                            headingTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            dataTextStyle: const TextStyle(
                              color: ColorConstants.darkGray,
                              fontSize: 13,
                            ),
                            columnSpacing: 16,
                            horizontalMargin: 12,
                            dividerThickness: 1,
                            border: TableBorder.all(color: ColorConstants.green, width: 1),
                            columns: const [
                              DataColumn(label: Text("POS")),
                              DataColumn(label: Text("STATE")),
                              DataColumn(label: Text("PLAYER NAME")),
                              DataColumn(label: Text("TODAY")),
                              DataColumn(label: Text("HOLE")),
                              DataColumn(label: Text("SCORE")),
                              DataColumn(label: Text("R1")),
                              DataColumn(label: Text("R2")),
                              DataColumn(label: Text("R3")),
                              DataColumn(label: Text("R4")),
                              DataColumn(label: Text("TOTAL GROSS")),
                              DataColumn(label: Text("TOTAL NET*")),
                            ],
                            rows: List.generate(leaderboardData.length, (index) {
                              final player = leaderboardData[index];
                              final todayColor = player["today"].toString().startsWith('-')
                                  ? ColorConstants.redAccent
                                  : ColorConstants.darkGray;

                              return DataRow(
                                color: MaterialStateProperty.all(
                                    index % 2 == 0 ? ColorConstants.lightGray : Colors.white),
                                cells: [
                                  DataCell(Text(player["pos"])),
                                  DataCell(Text(player["state"], style: const TextStyle(fontSize: 16))),
                                  DataCell(Text(player["name"], style: const TextStyle(fontWeight: FontWeight.bold))),
                                  DataCell(Text(player["today"], style: TextStyle(color: todayColor, fontWeight: FontWeight.bold))),
                                  DataCell(Text(player["hole"])),
                                  DataCell(Text(player["score"], style: const TextStyle(color: ColorConstants.redAccent))),
                                  DataCell(Text(player["r1"])),
                                  DataCell(Text(player["r2"])),
                                  DataCell(Text(player["r3"])),
                                  DataCell(Text(player["r4"])),
                                  DataCell(Text(player["gross"])),
                                  DataCell(Text(player["net"])),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
