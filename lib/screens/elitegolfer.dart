import 'package:delhi_golf_federation/components/color_constants.dart';
import 'package:delhi_golf_federation/components/topnavigationbar.dart';
import 'package:delhi_golf_federation/widgets/commonwebpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EliteGolferScreen extends StatefulWidget {
  const EliteGolferScreen({Key? key}) : super(key: key);

  @override
  State<EliteGolferScreen> createState() => _EliteGolferScreenState();
}

class _EliteGolferScreenState extends State<EliteGolferScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> proEliteData = [
    {
      "logo": "assets/images/owgr.png",
      "title": "OWGR",
      "link": "https://www.owgr.com/current-world-ranking",
    },
    // {
    //   "logo": "assets/images/pgti.png",
    //   "title": "PGTI",
    //   "link": "https://www.pgtofindia.com/stat/season",
    // },
    {
      "logo": "assets/images/dpworld.png",
      "title": "DP World",
      "link":
          "https://www.europeantour.com/dpworld-tour/rankings/overview/rankings/",
    },
    {
      "logo": "assets/images/let.png",
      "title": "LET",
      "link": "https://ladieseuropeantour.com/order-of-merit?id=2025&oom=PT",
    },
  ];

  final List<Map<String, String>> amateurEliteData = [
    {
      "logo": "assets/images/wagr.png",
      "title": "World Amateur Golf Ranking",
      "link": "https://www.wagr.com/mens-ranking",
    },
  ];

  final List<Map<String, String>> juniorEliteData = [
    {
      "logo": "assets/images/jgti.png",
      "title": "Junior Golf",
      "link": "https://app.juniorgolfhub.com/rankings",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Widget buildDataTable(List<Map<String, String>> data) {
    return ListView.builder(
      itemCount: data.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final item = data[index];
        return Card(
          color: ColorConstants.buttonColor, // 💚 Green background
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommonWebPageScreen(
                      title: item["title"]!,
                      url: item["link"]!,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Open",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopNavigationBar(
        showBackButton: true,
        onBackTap: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // 🔹 HEADER SECTION
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
                  "Elite Golfers",
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

          const SizedBox(height: 16),

          // 🔹 CUSTOM TOGGLE BUTTONS
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
                  const SizedBox(width: 8),
                  _buildTabButton("Amateur Elite", 1),
                  const SizedBox(width: 8),
                  _buildTabButton("Junior Elite", 2),
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
                buildDataTable(proEliteData),
                buildDataTable(amateurEliteData),
                buildDataTable(juniorEliteData),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isSelected ? Colors.white : ColorConstants.buttonColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
