import 'package:delhi_golf_federation/components/color_constants.dart';
import 'package:delhi_golf_federation/components/topnavigationbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClubGolferScreen extends StatefulWidget {
  const ClubGolferScreen({Key? key}) : super(key: key);

  @override
  State<ClubGolferScreen> createState() => _ClubGolferScreenState();
}

class _ClubGolferScreenState extends State<ClubGolferScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> stateWiseData = [
    {"logo": "assets/images/owgr.png", "title": "Delhi", "link": "Ranking"},
    {"logo": "assets/images/owgr.png", "title": "Punjab", "link": "Ranking"},
  ];

  final List<Map<String, String>> industryWiseData = [
    {"logo": "assets/images/pgti.png", "title": "Corporate", "link": "Ranking"},
  ];

  final List<Map<String, String>> professionalWiseData = [
    {
      "logo": "assets/images/dpworld.png",
      "title": "Professional Golfers",
      "link": "Ranking",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
                    "Club Golfers",
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
                    _buildTabButton("State Wise", 0),
                    const SizedBox(width: 8),
                    _buildTabButton("Industry Wise", 1),
                    const SizedBox(width: 8),
                    _buildTabButton("Professional Wise", 2),
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
                  buildDataTable(stateWiseData),
                  buildDataTable(industryWiseData),
                  buildDataTable(professionalWiseData),
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
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? ColorConstants.buttonColor : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorConstants.buttonColor),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,

            style: TextStyle(
              color: isSelected ? Colors.white : ColorConstants.buttonColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // 🔸 Data Table List Style
  Widget buildDataTable(List<Map<String, String>> data) {
    return ListView.builder(
      itemCount: data.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final item = data[index];
        return Card(
          color: ColorConstants.buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.white.withOpacity(0.2)),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 2,
          child: ListTile(
            leading: Image.asset(item["logo"]!, width: 50, height: 50),
            title: Text(
              item["title"]!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            trailing: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                item["link"]!,
                style: const TextStyle(
                  color: ColorConstants.buttonColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
