import 'package:flutter/material.dart';
import '../components/color_constants.dart'; // ✅ your theme colors

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFEFF2F1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ✅ Header with background + overlay + Profile text
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
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.4),
                  ),
                  const Text(
                    "Profile",
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

            // ✅ Profile Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Ravinder Zutshi",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "Designation",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildChip(Icons.group, "Friends 28"),
                                const SizedBox(width: 8),
                                _buildChip(Icons.sports_golf, "Club 16"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.grey),
                        onPressed: () {},
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ✅ Handicap
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: "Handicap\n",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: "18Birdies Handicap",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const Text(
                          "13.5",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ✅ All Rounds Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "All Rounds",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "More Stats",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildStatCard("Round Played", "200"),
                      _buildStatCard("Courses Played", "35"),
                      _buildStatCard("Avg. Score", "87.6"),
                      _buildStatCard("Best Round", "80"),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ✅ About Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "About",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Lawyer sit amet risus ac duin auctor posuere fanish amet "
                          "the acinia lecra fermen. Lawyer sit amet risus ac duin auctor "
                          "posuere fanish amet the acinia lecra fermen.",
                          style: TextStyle(color: Colors.black87, fontSize: 13),
                        ),
                        SizedBox(height: 12),
                        Text("Phone No.  :  +91 0987654321"),
                        Text("Email Id   :  info@delhigolffederation.com"),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // ✅ Profile Chips
  static Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: ColorConstants.buttonColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: ColorConstants.buttonColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: ColorConstants.buttonColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Stat Cards
  static Widget _buildStatCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
