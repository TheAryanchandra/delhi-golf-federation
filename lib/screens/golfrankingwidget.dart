import 'dart:async';
import 'package:delhi_golf_federation/bloc/auth/auth_bloc.dart';
import 'package:delhi_golf_federation/bloc/auth/auth_event.dart';
import 'package:delhi_golf_federation/bloc/auth/auth_state.dart';
import 'package:delhi_golf_federation/bloc/event_search/bloc/event_search_bloc.dart';
import 'package:delhi_golf_federation/bloc/event_search/bloc/event_search_event.dart';
import 'package:delhi_golf_federation/bloc/event_search/bloc/event_search_state.dart';
import 'package:delhi_golf_federation/data/event_search_repository.dart';
import 'package:delhi_golf_federation/data/auth_repository.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String? _selectedEventName;
  String? _selectedIndustry;
  Timer? _debounceTimer;
  late final IndustryBloc _industryBloc;
  late final EventSearchBloc _eventSearchBloc;

  @override
  void initState() {
    super.initState();
    _industryBloc = IndustryBloc(IndustryRepository())
      ..add(FetchIndustriesEvent());
    _eventSearchBloc = EventSearchBloc(EventSearchRepository());
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _industryBloc.close();
    _eventSearchBloc.close();
    super.dispose();
  }

  void _onSearchChanged(BuildContext blocContext, String value) {
    print("🔹 Search input changed: '$value'");

    _debounceTimer?.cancel();

    if (value.trim().length >= 3) {
      _debounceTimer = Timer(const Duration(milliseconds: 350), () {
        print("🔹 Triggering FetchEventSearch with query: '${value.trim()}'");
        blocContext
            .read<EventSearchBloc>()
            .add(FetchEventSearch(value.trim()));
      });
    } else if (value.isEmpty) {
      print("🔹 Search input empty, clearing search results");
      blocContext.read<EventSearchBloc>().add(FetchEventSearch(""));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<IndustryBloc>.value(value: _industryBloc),
        BlocProvider<EventSearchBloc>.value(value: _eventSearchBloc),
      ],
      child: Builder(
        builder: (context) => _buildClubGolfersContent(context),
      ),
    );
  }

  Widget _buildClubGolfersContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Top Row: Search + Industry
          Row(
            children: [
              // Search Field
              Expanded(
                flex: 2,
                child: BlocBuilder<EventSearchBloc, EventSearchState>(
                  builder: (context, state) {
                    print(
                      "🔹 BlocBuilder EventSearchBloc: State updated -> $state",
                    );
                    print(
                      "🔹 _searchController.text: '${_searchController.text}'",
                    );

                    return SizedBox(
                      height:
                          60, // height of TextField (dropdown will float over it)
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // 🔹 TextField
                          TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search Event...',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              print("🔹 Search input changed: '$value'");
                              _onSearchChanged(context, value);
                            },
                          ),

                          // 🔹 Dropdown suggestions
                          if (state is EventSearchLoaded &&
                              _searchController.text.trim().length >= 3 &&
                              state.events.isNotEmpty)
                            Positioned(
                              top: 60, // just below the TextField
                              left: 0,
                              right: 0,
                              child: Material(
                                elevation: 4,
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  height: 250, // fixed height for dropdown
                                  child: ListView.separated(
                                    padding: EdgeInsets.zero,
                                    itemCount: state.events.length,
                                    separatorBuilder: (_, __) => Divider(
                                      height: 1,
                                      color: Colors.grey.shade200,
                                    ),
                                    itemBuilder: (context, index) {
                                      final event = state.events[index];
                                      print(
                                        "🔹 Displaying event: ${event.name} | ID: ${event.id}",
                                      );
                                      return ListTile(
                                        dense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                        title: Text(
                                          event.name ?? 'Unknown Event',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        // subtitle: Text(
                                        //   'ID: ${event.id ?? '-'} | Ref: ${event.refNo ?? '-'}',
                                        //   style: TextStyle(
                                        //     fontSize: 12,
                                        //     color: Colors.grey.shade600,
                                        //   ),
                                        // ),
                                        onTap: () {
                                          setState(() {
                                            _selectedEventName = event.name;
                                            _searchController.text =
                                                event.name ?? '';
                                          });
                                          print(
                                            "🔹 Selected event: ${event.name}",
                                          );
                                          FocusScope.of(context).unfocus();
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),

                          // 🔹 Loading indicator
                          if (state is EventSearchLoading)
                            const Positioned(
                              top: 60,
                              left: 0,
                              right: 0,
                              child: Center(child: CircularProgressIndicator()),
                            ),

                          // 🔹 Error message
                          if (state is EventSearchError)
                            Positioned(
                              top: 60,
                              left: 0,
                              right: 0,
                              child: Text(
                                "Error: ${state.message}",
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 16),

              // Industry Dropdown
              Expanded(
                flex: 2,
                child: BlocBuilder<IndustryBloc, IndustryState>(
                  builder: (context, state) {
                    print(
                      "🔹 BlocBuilder IndustryBloc: State updated -> $state",
                    );

                    if (state is IndustryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is IndustryLoaded) {
                      return Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedIndustry,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            hintText: "Select industry",
                            border: InputBorder.none,
                          ),
                          items: state.industries
                              .map(
                                (industry) => DropdownMenuItem<String>(
                                  value: industry.refNo,
                                  child: Text(
                                    industry.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedIndustry = value;
                            });
                            print("🔹 Selected industry: $value");
                          },
                        ),
                      );
                    } else if (state is IndustryError) {
                      return Text(
                        "Failed to load industries: ${state.message}",
                        style: const TextStyle(color: Colors.red),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Table Section
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 500,
                child: Column(
                  children: [
                    // Table Header
                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //     vertical: 12,
                    //     horizontal: 8,
                    //   ),
                    //   decoration: const BoxDecoration(color: Colors.green),
                    //   child: const Row(
                    //     children: [
                    //       Expanded(
                    //         flex: 1,
                    //         child: Center(
                    //           child: Text(
                    //             "SR. NO",
                    //             style: TextStyle(
                    //               color: Colors.white,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         flex: 3,
                    //         child: Center(
                    //           child: Text(
                    //             "NAME",
                    //             style: TextStyle(
                    //               color: Colors.white,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         flex: 2,
                    //         child: Center(
                    //           child: Text(
                    //             "SCORE",
                    //             style: TextStyle(
                    //               color: Colors.white,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // Table Rows (Static Demo)
                    // Expanded(
                    //   child: ListView.builder(
                    //     itemCount: 10,
                    //     itemBuilder: (context, index) {
                    //       final isEven = index % 2 == 0;
                    //       return Container(
                    //         color: isEven
                    //             ? const Color(0xFF046B45)
                    //             : const Color(0xFF12563C),
                    //         padding: const EdgeInsets.symmetric(vertical: 12),
                    //         child: Row(
                    //           children: [
                    //             Expanded(
                    //               flex: 1,
                    //               child: Center(
                    //                 child: Text(
                    //                   (index + 1).toString(),
                    //                   style: const TextStyle(
                    //                     color: Colors.white,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //             Expanded(
                    //               flex: 3,
                    //               child: Center(
                    //                 child: Text(
                    //                   _selectedEventName ?? "Swing for Hope",
                    //                   style: const TextStyle(
                    //                     color: Colors.white,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //             Expanded(
                    //               flex: 2,
                    //               child: Center(
                    //                 child: Text(
                    //                   "-${index + 1}",
                    //                   style: const TextStyle(
                    //                     color: Colors.white,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
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
