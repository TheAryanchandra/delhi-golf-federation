import 'package:delhi_golf_federation/widgets/amatuerelite_widget.dart';
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
class RankingTable extends StatefulWidget {
  final String action;
  final String? id; // example: "ProEliteData", "AmateurEliteData"
  const RankingTable({super.key, required this.action, this.id});

  @override
  State<RankingTable> createState() => _RankingTableState();
}

class _RankingTableState extends State<RankingTable> {
  int currentPage = 1;

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
    });
    _fetchData();
  }

  void _fetchData() {
    context.read<GolfRankingBloc>().add(
      FetchGolfRankingEvent(
        GolfRankingRequest(
          action: widget.action,
          id: widget.id,
          pageSize: 10, // hardcoded
          page: currentPage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GolfRankingBloc, GolfRankingState>(
      builder: (context, state) {
        if (state is GolfRankingInitial) {
          // 🔸 Trigger API call for given action
          _fetchData();
          return const Center(child: CircularProgressIndicator());
        } else if (state is GolfRankingLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GolfRankingLoaded) {
          final players = state.response.response?.players ?? [];
          final totalRecords =
              state.response.response?.totalPage ?? players.length;
          final totalPages = players.isEmpty ? 1 : (totalRecords / 10).ceil();

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
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: ColorConstants.buttonColor,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Header Row
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: ColorConstants.buttonColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "NAME",
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
                                  "OWGR RANK",
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
                                  "INDIA RANK",
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
                                  "TOTAL SCORE",
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        player.name ?? "-",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        player.ranks?.toString() ?? "-",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        player.stateRank?.toString() ?? "-",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        player.totalScore?.toString() ?? "-",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
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
                ),

                // Pagination UI
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 16),
                        onPressed: currentPage > 1
                            ? () => _onPageChanged(currentPage - 1)
                            : null,
                      ),
                      ...List.generate(totalPages, (index) {
                        final page = index + 1;
                        final isActive = page == currentPage;
                        return GestureDetector(
                          onTap: () => _onPageChanged(page),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xFF0B592A)
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "$page",
                              style: TextStyle(
                                color: isActive ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        onPressed: currentPage < totalPages
                            ? () => _onPageChanged(currentPage + 1)
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (state is GolfRankingError) {
          return Center(
            child: Text(
              "Error: ${state.message}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

/// 🔹 Amateur Elite Section (Gentlemen / Ladies)
class AmateurEliteSection extends StatefulWidget {
  final TabController tabController;
  const AmateurEliteSection({super.key, required this.tabController});

  @override
  State<AmateurEliteSection> createState() => _AmateurEliteSectionState();
}

class _AmateurEliteSectionState extends State<AmateurEliteSection> {
  int selectedIndex = 0; // 0 = Gentlemen, 1 = Ladies
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    _fetchData(); // initial fetch
  }

  void _fetchData() {
    final id = selectedIndex == 0 ? "Gentlemen" : "Ladies";
    print("📡 Fetching AmateurEliteData for $id, Page: $currentPage");

    context.read<GolfRankingBloc>().add(
      FetchGolfRankingEvent(
        GolfRankingRequest(
          action: "AmateurEliteData",
          id: id,
          pageSize: 10, // hardcoded
          page: currentPage,
        ),
      ),
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
    });
    _fetchData();
  }

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
        const SizedBox(height: 12),

        /// 🔹 Custom AmateurElite Table
        Expanded(
          child: BlocBuilder<GolfRankingBloc, GolfRankingState>(
            builder: (context, state) {
              if (state is GolfRankingLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GolfRankingLoaded) {
                final data = state.response?.response?.players ?? [];
                final totalRecords =
                    state.response.response?.totalPage ?? data.length;
                final totalPages = data.isEmpty
                    ? 1
                    : (totalRecords / 10).ceil();
                return AmateurEliteTable(
                  players: data,
                  currentPage: currentPage,
                  totalPages: totalPages,
                  onPageChanged: _onPageChanged,
                );
              } else if (state is GolfRankingError) {
                return Center(child: Text("Error: ${state.message}"));
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubTabButton(String text, int index) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (selectedIndex == index) return;
          setState(() => selectedIndex = index);
          _fetchData();
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
}

/// 🔹 Junior Elite Section
class JuniorEliteSection extends StatefulWidget {
  final String selectedGender;
  final String selectedCategory;

  const JuniorEliteSection({
    super.key,
    required this.selectedGender,
    required this.selectedCategory,
  });

  @override
  State<JuniorEliteSection> createState() => _JuniorEliteSectionState();
}

class _JuniorEliteSectionState extends State<JuniorEliteSection> {
  late String _gender;
  late String _category;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    _gender = widget.selectedGender;
    _category = widget.selectedCategory;
    _fetchData();
  }

  void _fetchData() {
    context.read<GolfRankingBloc>().add(
      FetchGolfRankingEvent(
        GolfRankingRequest(
          action: "JuniorEliteData",
          id: _gender,
          entryType: _category,
          pageSize: 10, // hardcoded
          page: currentPage,
        ),
      ),
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
    });
    _fetchData();
  }

  void _onGenderChanged(String value) {
    setState(() {
      _gender = value;
      currentPage = 1; // reset page on filter change
      _fetchData();
    });
  }

  void _onCategoryChanged(String value) {
    setState(() {
      _category = value;
      currentPage = 1; // reset page on filter change
      _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 12),
          _buildSelectableRow(["Boys", "Girls"], _gender, _onGenderChanged),
          const SizedBox(height: 12),
          _buildSelectableRow(
            ["Category A", "Category B", "Category C"],
            _category,
            _onCategoryChanged,
          ),
          const SizedBox(height: 12),

          /// 🔹 Table UI identical to AmateurEliteTable / ProElite
          Expanded(
            child: BlocBuilder<GolfRankingBloc, GolfRankingState>(
              builder: (context, state) {
                if (state is GolfRankingLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GolfRankingLoaded) {
                  final players = state.response?.response?.players ?? [];
                  final totalRecords =
                      state.response.response?.totalPage ?? players.length;
                  final totalPages = players.isEmpty
                      ? 1
                      : (totalRecords / 10).ceil();

                  if (players.isEmpty) {
                    return Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: ColorConstants.buttonColor,
                          width: 1.5,
                        ),
                      ),
                      child: const Text(
                        "No players found.",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: ColorConstants.buttonColor,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                // Table Header
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorConstants.buttonColor,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "NAME",
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
                                          "IGU RANK",
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
                                          "DELHI STATE RANK",
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
                                          "TOTAL SCORE",
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

                                // Table Data
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: players.length,
                                    itemBuilder: (context, index) {
                                      final player = players[index];
                                      final isEven = index % 2 == 0;
                                      return Container(
                                        color: isEven
                                            ? const Color.fromARGB(
                                                255,
                                                4,
                                                107,
                                                69,
                                              )
                                            : const Color(0xFF12563C),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: Text(
                                                player.name ?? "-",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                player.ranks?.toString() ?? "-",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                player.stateRank?.toString() ??
                                                    "-",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                player.totalScore?.toString() ??
                                                    "-",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
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
                        ),

                        // Pagination UI
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  size: 16,
                                ),
                                onPressed: currentPage > 1
                                    ? () => _onPageChanged(currentPage - 1)
                                    : null,
                              ),
                              ...List.generate(totalPages, (index) {
                                final page = index + 1;
                                final isActive = page == currentPage;
                                return GestureDetector(
                                  onTap: () => _onPageChanged(page),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? const Color(0xFF0B592A)
                                          : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "$page",
                                      style: TextStyle(
                                        color: isActive
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                ),
                                onPressed: currentPage < totalPages
                                    ? () => _onPageChanged(currentPage + 1)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is GolfRankingError) {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
                      // decoration: BoxDecoration(
                      //   color: Colors.red.withOpacity(0.1), // subtle background
                      //   borderRadius: BorderRadius.circular(12),
                      // ),
                      child: const Text(
                        "No data found",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectableRow(
    List<String> options,
    String selected,
    ValueChanged<String> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF084B36),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: options
            .map(
              (opt) => Expanded(
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

/// 🔹 Club Golfers Table

class ClubGolfersTable extends StatefulWidget {
  const ClubGolfersTable({super.key});

  @override
  State<ClubGolfersTable> createState() => _ClubGolfersTableState();
}

class _ClubGolfersTableState extends State<ClubGolfersTable> {
  int currentPage = 1;

  final List<Map<String, dynamic>> allGolfers = List.generate(15, (index) {
    return {
      "srNo": index + 1,
      "profile": "assets/images/owgr.png",
      "name": "Player ${index + 1}",
      "position": index + 1,
      "score": -9 + index,
      "playerPoint": 5 - (index % 5),
    };
  });

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageSize = 10;
    final totalPages = (allGolfers.length / pageSize).ceil();
    final golfers = allGolfers
        .skip((currentPage - 1) * pageSize)
        .take(pageSize)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Table Container with horizontal scrolling
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: 450, // set minimum width for table to allow horizontal scroll
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: ColorConstants.buttonColor,
                    width: 1.5,
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                child: Column(
                  children: [
                    // Table Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 8),
                      decoration: const BoxDecoration(
                        color: ColorConstants.buttonColor,
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  "SR. NO",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  "PROFILE",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: Text(
                                  "NAME",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  "POSITION",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  "SCORE",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  "PLAYER POINT",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Table Rows
                    Expanded(
                      child: ListView.builder(
                        itemCount: golfers.length,
                        itemBuilder: (context, index) {
                          final golfer = golfers[index];
                          final isEven = index % 2 == 0;
                          return Container(
                            color: isEven
                                ? const Color(0xFF046B45)
                                : const Color(0xFF12563C),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                // SR. NO
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      golfer["srNo"].toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                // PROFILE
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Image.asset(
                                      golfer["profile"],
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                                ),
                                // NAME
                                Expanded(
                                  flex: 3,
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: golfer["name"]
                                          .toString()
                                          .split(" ")
                                          .map((word) => Text(
                                                word,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ),
                                // POSITION
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Text(
                                      golfer["position"].toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                // SCORE
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Text(
                                      golfer["score"].toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                // PLAYER POINT
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Text(
                                      golfer["playerPoint"].toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.white),
                                    ),
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
            ),
          ),
        ],
      ),
    );
  }
}
