import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String selectedSeason = "Golf Club Invitational";

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// Banner Header (Image + Text) like EventsScreen
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background Image
                Image.asset(
                  "assets/images/welcome.png",
                  height: screenHeight * 0.125, // reduced height
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                // Dark overlay
                Container(
                  height: screenHeight * 0.125,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.4),
                ),

                // Title Text
                const Text(
                  "Leaderboard",
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

          const SizedBox(height: 12),

          /// Season Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSeasonButton("Spring Season"),
                _buildSeasonButton("Golf Club Invitational"),
                _buildSeasonButton("Fall Season"),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// Season Content
          Expanded(
            child: _buildSeasonContent(),
          ),
        ],
      ),
    );
  }

  /// Season Button widget
  Widget _buildSeasonButton(String title) {
    final bool isSelected = selectedSeason == title;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              selectedSeason = title;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isSelected ? const Color(0xFF0B592A) : Colors.white,
            foregroundColor:
                isSelected ? Colors.white : const Color(0xFF0B592A),
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Color(0xFF0B592A)),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  /// Season content logic
  Widget _buildSeasonContent() {
    if (selectedSeason == "Spring Season" || selectedSeason == "Fall Season") {
      return const Center(
        child: Text(
          "Coming Soon",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      );
    }

    // Golf Club Invitational table
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 16,
            dataRowMinHeight: 32,
            dataRowMaxHeight: 40,
            headingRowColor: MaterialStateColor.resolveWith(
                (states) => const Color(0xFFEFEFEF)),
            columns: const [
              DataColumn(label: Text("#")),
              DataColumn(label: Text("Name")),
              DataColumn(label: Text("To PAR")),
              DataColumn(label: Text("THRU")),
              DataColumn(label: Text("Today")),
            ],
            rows: List.generate(
              40,
              (index) => DataRow(
                cells: [
                  DataCell(Text("${index + 1}")),
                  DataCell(
                    Text(
                      "Player ${index + 1} | HCP ${10 + (index % 15)}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  DataCell(
                    Center(
                      child: Text(
                        index % 2 == 0 ? "-${index % 5}" : "E",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'RobotoMono',
                          color: index % 2 == 0 ? Colors.red : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  DataCell(Text("${(index % 9) + 1}")),
                  DataCell(
                    Text(
                      index % 3 == 0 ? "-2" : "-4",
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
