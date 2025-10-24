import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:delhi_golf_federation/components/color_constants.dart';
import 'package:delhi_golf_federation/components/topnavigationbar.dart';

class DelhiGolfRankingScreen extends StatefulWidget {
  const DelhiGolfRankingScreen({Key? key}) : super(key: key);

  @override
  State<DelhiGolfRankingScreen> createState() => _DelhiGolfRankingScreenState();
}

class _DelhiGolfRankingScreenState extends State<DelhiGolfRankingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _amateurSubTabController;

  String _selectedGender = "Boys";
  String _selectedCategory = "Category A";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _amateurSubTabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.urbanistTextTheme(Theme.of(context).textTheme)
            .copyWith(
              bodyMedium: const TextStyle(fontSize: 15, color: Colors.black),
              titleLarge: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: TopNavigationBar(
          showBackButton: true,
          onBackTap: () => Navigator.pop(context),
        ),
        body: Column(
          children: [
            // 🔹 HEADER
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
                    "Delhi Golf Rankings",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 TAB BUTTONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: ColorConstants.buttonColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildTabButton("Pro Elite", 0),
                    const SizedBox(width: 6),
                    _buildTabButton("Amateur Elite", 1),
                    const SizedBox(width: 6),
                    _buildTabButton("Junior Elite", 2),
                    const SizedBox(width: 6),
                    _buildTabButton("Club Golfers", 3),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 🔹 TAB CONTENT
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // 🟢 Pro Elite
                  _buildRankingTable(),

                  // 🟢 Amateur Elite
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: ColorConstants.buttonColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              _buildSubTabButton("Gentlemen", 0),
                              const SizedBox(width: 6),
                              _buildSubTabButton("Ladies", 1),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _amateurSubTabController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildRankingTable(title: "Gentlemen"),
                            _buildRankingTable(title: "Ladies"),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // 🟢 Junior Elite (Custom Layout)
                  _buildJuniorEliteSection(),

                  // 🟢 Club Golfers
                  // 🟢 Club Golfers
                  _buildClubGolfersTable(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔸 Custom Tab Button
  Widget _buildTabButton(String text, int index) {
    final isSelected = _tabController.index == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _tabController.index = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? ColorConstants.buttonColor : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColorConstants.buttonColor),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              color: isSelected ? Colors.white : ColorConstants.buttonColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  // 🔸 Sub Tab Buttons (Gentlemen/Ladies)
  Widget _buildSubTabButton(String text, int index) {
    final isSelected = _amateurSubTabController.index == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _amateurSubTabController.index = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? ColorConstants.buttonColor : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColorConstants.buttonColor),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : ColorConstants.buttonColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  // 🔸 Default Ranking Table
  Widget _buildRankingTable({String? title}) {
    final List<Map<String, String>> players = [
      {
        "name": "Shubhankar Sharma",
        "owgr": "525",
        "india": "1",
        "score": "13.61177",
      },
      {
        "name": "Veer Ahlawat",
        "owgr": "542",
        "india": "2",
        "score": "13.03476",
      },
      {
        "name": "Yuvraj Sandhu",
        "owgr": "568",
        "india": "3",
        "score": "11.33504",
      },
      {
        "name": "Rayhan Thomas",
        "owgr": "670",
        "india": "4",
        "score": "7.61581",
      },
      {
        "name": "Gaganjeet Bhullar",
        "owgr": "675",
        "india": "5",
        "score": "7.59220",
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ColorConstants.buttonColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Table Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: ColorConstants.buttonColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Expanded(
                    flex: 4,
                    child: Text(
                      "NAME",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "OWGR",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "INDIA",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "SCORE",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: Colors.white),

            // Table Body
            Expanded(
              child: ListView.separated(
                itemCount: players.length,
                separatorBuilder: (context, index) => Divider(
                  color: ColorConstants.buttonColor.withOpacity(0.3),
                  thickness: 1,
                  height: 0,
                ),
                itemBuilder: (context, index) {
                  final player = players[index];
                  final bool isEven = index % 2 == 0;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isEven
                          ? const Color.fromARGB(255, 4, 107, 69)
                          : const Color(0xFF12563C),
                      borderRadius: index == players.length - 1
                          ? const BorderRadius.vertical(
                              bottom: Radius.circular(16),
                            )
                          : BorderRadius.zero,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            player["name"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            player["owgr"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            player["india"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            player["score"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔸 Junior Elite Custom Section
  Widget _buildJuniorEliteSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF003F2F),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),

            // 🔹 Boys/Girls Toggle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF084B36),
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSelectableSmallTab(
                    text: "Boys",
                    selected: _selectedGender == "Boys",
                    onTap: () {
                      setState(() {
                        _selectedGender = "Boys";
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  _buildSelectableSmallTab(
                    text: "Girls",
                    selected: _selectedGender == "Girls",
                    onTap: () {
                      setState(() {
                        _selectedGender = "Girls";
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 🔹 Category Tabs
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF084B36),
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSelectableSmallTab(
                    text: "Category A",
                    selected: _selectedCategory == "Category A",
                    onTap: () {
                      setState(() {
                        _selectedCategory = "Category A";
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  _buildSelectableSmallTab(
                    text: "Category B",
                    selected: _selectedCategory == "Category B",
                    onTap: () {
                      setState(() {
                        _selectedCategory = "Category B";
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  _buildSelectableSmallTab(
                    text: "Category C",
                    selected: _selectedCategory == "Category C",
                    onTap: () {
                      setState(() {
                        _selectedCategory = "Category C";
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 🔹 Header Text (Dynamic)
            // Text(
            //   "Junior $_selectedGender $_selectedCategory Merit List as on 01 Sept 2025",
            //   style: const TextStyle(
            //     color: Colors.white,
            //     fontWeight: FontWeight.w500,
            //     fontSize: 14,
            //   ),
            // ),
            const SizedBox(height: 12),

            // 🔹 Table Section
            Expanded(
              child: _buildRankingTable(
                title: "$_selectedGender $_selectedCategory",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectableSmallTab({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? const Color.fromARGB(255, 4, 107, 69)
                : const Color(0xFF12563C),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallTab(String text, bool selected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? const Color.fromARGB(255, 4, 107, 69)
              : const Color(0xFF12563C),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // 🔹 Club Golfers Table Layout (Custom)
  // 🔹 Club Golfers Table Layout (Compact + Unified Style)
// 🔹 Club Golfers Table Layout (Compact & Fixed)
// 🔹 Club Golfers Table Layout (Updated & Color-Matched)
Widget _buildClubGolfersTable() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFF003F2F),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // 🔍 Search Box
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Enter Event Name",
                  hintStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF12563C),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),

            // 🏁 Table Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 4, 107, 69), // Deep green
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Expanded(
                    flex: 2,
                    child: Text(
                      "SR. NO",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      "PROFILE",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      "NAME",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "POSITION",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "SCORE",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      "PLAYER POINT",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🧾 Table Rows
            Container(
              decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Column(
                children: List.generate(5, (index) {
                  final rowColor = index % 2 == 0
                      ? const Color.fromARGB(255, 4, 107, 69) // Dark green
                      : const Color(0xFF12563C); // Lighter green

                  return Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    decoration: BoxDecoration(
                      color: rowColor,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black.withOpacity(0.2),
                          width: 0.3,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "${index + 1}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Image.asset(
                            "assets/images/owgr.png",
                            height: 30,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const Expanded(
                          flex: 3,
                          child: Text(
                            "OWGR",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Text(
                            "1",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Text(
                            "-9",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ),
                        const Expanded(
                          flex: 3,
                          child: Text(
                            "4",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
