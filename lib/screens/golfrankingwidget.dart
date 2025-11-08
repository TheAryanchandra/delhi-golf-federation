import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:delhi_golf_federation/components/color_constants.dart';
import 'package:delhi_golf_federation/bloc/golfranking/bloc/golf_ranking_bloc.dart';
import 'package:delhi_golf_federation/bloc/golfranking/bloc/golf_ranking_event.dart';
import 'package:delhi_golf_federation/bloc/golfranking/bloc/golf_ranking_state.dart';
import 'package:delhi_golf_federation/model/golf_ranking_model.dart';

/// 🔹 Header Section
class RankingHeader extends StatelessWidget {
  final double screenHeight;
  const RankingHeader({super.key, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/images/welcome.png",
            height: screenHeight * 0.10,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            height: screenHeight * 0.09,
            color: Colors.black.withOpacity(0.35),
          ),
          const Text(
            "Delhi Golf Rankings",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔹 Main Tab Bar
class RankingTabBar extends StatelessWidget {
  final TabController tabController;
  final Function(int) onTabSelected;
  const RankingTabBar({
    super.key,
    required this.tabController,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }

  Widget _buildTabButton(String text, int index) {
    final isSelected = tabController.index == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
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
}

/// 🔹 Dynamic Table with API Integration
class RankingTable extends StatelessWidget {
  final String action; // example: "ProEliteData", "AmateurEliteData"
  const RankingTable({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GolfRankingBloc, GolfRankingState>(
      builder: (context, state) {
        if (state is GolfRankingInitial) {
          // 🔸 Trigger API call for given action
          context.read<GolfRankingBloc>().add(
                FetchGolfRankingEvent(
                  GolfRankingRequest(action: action),
                ),
              );
          return const Center(child: CircularProgressIndicator());
        } else if (state is GolfRankingLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GolfRankingLoaded) {
          final players = state.response.response?.players ?? [];

          if (players.isEmpty) {
            return const Center(
              child: Text(
                "No players found.",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: ColorConstants.buttonColor, width: 1.5),
              ),
              child: Column(
                children: [
                  // Header Row
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: ColorConstants.buttonColor,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Text("NAME",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                        Expanded(
                            flex: 2,
                            child: Text("OWGR RANK",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                        Expanded(
                            flex: 2,
                            child: Text("INDIA RANK",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                        Expanded(
                            flex: 2,
                            child: Text("TOTAL SCORE",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      itemCount: players.length,
                      itemBuilder: (context, index) {
                        final player = players[index];
                        final isEven = index % 2 == 0;
                        return Container(
                          color: isEven
                              ? const Color.fromARGB(255, 4, 107, 69)
                              : const Color(0xFF12563C),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                  flex: 4,
                                  child: Text(player.name ?? "-",
                                      textAlign: TextAlign.center,
                                      style:
                                          const TextStyle(color: Colors.white))),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                      player.ranks?.toString() ?? "-",
                                      textAlign: TextAlign.center,
                                      style:
                                          const TextStyle(color: Colors.white))),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                      player.stateRank?.toString() ?? "-",
                                      textAlign: TextAlign.center,
                                      style:
                                          const TextStyle(color: Colors.white))),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                      player.totalScore?.toString() ?? "-",
                                      textAlign: TextAlign.center,
                                      style:
                                          const TextStyle(color: Colors.white))),
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
        } else if (state is GolfRankingError) {
          return Center(
              child: Text(
            "Error: ${state.message}",
            style: const TextStyle(color: Colors.red),
          ));
        }
        return const SizedBox.shrink();
      },
    );
  }
}

/// 🔹 Amateur Elite Section (Gentlemen / Ladies)
class AmateurEliteSection extends StatelessWidget {
  final TabController tabController;
  const AmateurEliteSection({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
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
                _buildSubTabButton("Gentlemen", 0),
                const SizedBox(width: 6),
                _buildSubTabButton("Ladies", 1),
              ],
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              RankingTable(action: "Gentlemen"),
              RankingTable(action: "Ladies"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubTabButton(String text, int index) {
    final isSelected = tabController.index == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => tabController.index = index,
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
}

/// 🔹 Junior Elite Section
class JuniorEliteSection extends StatelessWidget {
  final String selectedGender;
  final String selectedCategory;
  final ValueChanged<String> onGenderChanged;
  final ValueChanged<String> onCategoryChanged;

  const JuniorEliteSection({
    super.key,
    required this.selectedGender,
    required this.selectedCategory,
    required this.onGenderChanged,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
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
            _buildSelectableRow(["Boys", "Girls"], selectedGender, onGenderChanged),
            const SizedBox(height: 12),
            _buildSelectableRow(
              ["Category A", "Category B", "Category C"],
              selectedCategory,
              onCategoryChanged,
            ),
            const SizedBox(height: 12),
            Expanded(child: RankingTable(action: "$selectedGender $selectedCategory")),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectableRow(
      List<String> options, String selected, ValueChanged<String> onChanged) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF084B36),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: options
            .map((opt) => Expanded(
                  child: GestureDetector(
                    onTap: () => onChanged(opt),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: selected == opt
                            ? const Color.fromARGB(255, 4, 107, 69)
                            : const Color(0xFF12563C),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        opt,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

/// 🔹 Club Golfers Table
class ClubGolfersTable extends StatelessWidget {
  const ClubGolfersTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF003F2F),
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text("Club Golfers Table Placeholder",
                  style: TextStyle(color: Colors.white)),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
