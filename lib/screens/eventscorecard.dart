import 'package:delhi_golf_federation/components/custombutton.dart';
import 'package:delhi_golf_federation/config/routes_name.dart';
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

  final PageController _pageController = PageController();
  int currentHoleIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int get totalScore => holes.fold(0, (sum, hole) => sum + (hole["score"] as int));
  int get totalPar => holes.fold(0, (sum, hole) => sum + (hole["par"] as int));

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF12563C);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
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
      body: Column(
        children: [
          const SizedBox(height: 16),

          // 🏌️‍♂️ Player Info
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: mainColor.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Delhi Golf Championship 2025",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Player: Aryan Chandra",
                        style: TextStyle(fontSize: 16, color: Colors.black87)),
                    Text("Handicap: 12",
                        style: TextStyle(fontSize: 16, color: Colors.black87)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 🎯 Hole Selector Scroll
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: holes.length,
              itemBuilder: (context, index) {
                final isSelected = index == currentHoleIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentHoleIndex = index;
                    });
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? mainColor : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color:
                              isSelected ? mainColor : mainColor.withOpacity(0.3)),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: mainColor.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Hole ${holes[index]['hole']}",
                        style: TextStyle(
                          color: isSelected ? Colors.white : mainColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // 📄 Hole Detail View
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentHoleIndex = index;
                });
              },
              itemCount: holes.length,
              itemBuilder: (context, index) {
                final hole = holes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: mainColor.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Hole ${hole['hole']}",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: mainColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Par: ${hole['par']}",
                                style: const TextStyle(fontSize: 16)),
                            Text("Index: ${hole['index']}",
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          initialValue: hole["score"].toString(),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: "Enter Score",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: mainColor, width: 1.5),
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              hole["score"] = int.tryParse(val) ?? 0;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // 🔘 Next / Submit Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: currentHoleIndex == holes.length - 1
                    ? "Submit"
                    : "Next Hole",
                backgroundColor: mainColor,
                onPressed: () {
                  if (currentHoleIndex < holes.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    Navigator.pushNamed(context, RoutesName.finalScorecard, arguments: holes);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
