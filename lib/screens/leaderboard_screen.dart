import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:delhi_golf_federation/bloc/leaderboard/bloc/leaderboardScreen_bloc.dart';
import 'package:delhi_golf_federation/bloc/leaderboard/bloc/leaderboardScreen_event.dart';
import 'package:delhi_golf_federation/bloc/leaderboard/bloc/leaderboardScreen_state.dart';
import 'package:delhi_golf_federation/data/leaderboardScreen_repository.dart';

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
  late LeaderboardScreenBloc _bloc;
  int currentPage = 1;
  final int pageSize = 10; // Constant as per API

  @override
  void initState() {
    super.initState();
    _bloc = LeaderboardScreenBloc(LeaderboardScreenRepository());
    _bloc.add(FetchLeaderboardScreenEvent(currentPage));
  }

  void _nextPage(int totalPages) {
    if (currentPage < totalPages) {
      setState(() {
        currentPage++;
      });
      _bloc.add(FetchLeaderboardScreenEvent(currentPage));
    }
  }

  void _previousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
      _bloc.add(FetchLeaderboardScreenEvent(currentPage));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocProvider(
          create: (_) => _bloc,
          child: BlocBuilder<LeaderboardScreenBloc, LeaderboardScreenState>(
            builder: (context, state) {
              if (state is LeaderboardScreenLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: ColorConstants.green),
                );
              } else if (state is LeaderboardScreenLoaded) {
                final data = state.leaderboardData;
                final players = data.response?.players ?? [];
                final totalPages = data.response?.totalPage ?? 1;

                return Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/ranthumbor.png',
                            height: 60,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "ROYAL RANTHAMBORE LEADERBOARD",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorConstants.green,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// TABLE VIEW
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Material(
                            elevation: 4,
                            shadowColor: Colors.black26,
                            child: Scrollbar(
                              controller: _scrollController,
                              thumbVisibility: true,
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: MediaQuery.of(context).size.width,
                                  ),
                                  child: DataTable(
                                    headingRowColor: MaterialStateProperty.all(
                                      ColorConstants.green,
                                    ),
                                    headingTextStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                    dataTextStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                    columnSpacing: 16,
                                    horizontalMargin: 12,
                                    dividerThickness: 1,
                                    border: TableBorder.all(
                                      color: Colors
                                          .white70, // Lighter border on green
                                      width: 0.8,
                                    ),
                                    columns: const [
                                      DataColumn(label: Text("POS")),
                                      DataColumn(label: Text("STATE")),
                                      DataColumn(label: Text("PLAYER NAME")),
                                      DataColumn(label: Text("SCORE")),
                                      DataColumn(label: Text("TODAY")),
                                      DataColumn(label: Text("R1")),
                                      DataColumn(label: Text("R2")),
                                      DataColumn(label: Text("R3")),
                                      DataColumn(label: Text("R4")),
                                      DataColumn(label: Text("THRU")),
                                      DataColumn(label: Text("TOTAL GROSS")),
                                      DataColumn(label: Text("TOTAL NET*")),
                                    ],
                                    rows: List.generate(players.length, (
                                      index,
                                    ) {
                                      final player = players[index];
                                      final todayValue =
                                          player.today?.toString() ?? "0";

                                      return DataRow(
                                        color: MaterialStateProperty.all(
                                          index % 2 == 0
                                              ? const Color.fromARGB(
                                                  255,
                                                  4,
                                                  107,
                                                  69,
                                                ) // Dark green for even rows
                                              : const Color(
                                                  0xFF12563C,
                                                ), // Slightly lighter green for odd rows
                                        ),

                                        cells: [
                                          DataCell(Text("${index + 1}")),
                                          DataCell(
                                            Center(
                                              child: Row(
                                                mainAxisSize: MainAxisSize
                                                    .min, // Shrinks row to content width
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    "🇮🇳 ",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    player.stateName ?? "",
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          DataCell(
                                            Text(
                                              player.playerName ?? "",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              player.score?.toString() ?? "0",
                                              style: TextStyle(
                                                color: (player.score ?? 0) < 0
                                                    ? Colors.redAccent.shade100
                                                    : Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              todayValue,
                                              style: TextStyle(
                                                color:
                                                    (double.tryParse(
                                                              todayValue,
                                                            ) ??
                                                            0) <
                                                        0
                                                    ? Colors.redAccent.shade100
                                                    : Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(player.r1?.toString() ?? "0"),
                                          ),
                                          DataCell(
                                            Text(player.r2?.toString() ?? "0"),
                                          ),
                                          DataCell(
                                            Text(player.r3?.toString() ?? "0"),
                                          ),
                                          DataCell(
                                            Text(player.r4?.toString() ?? "0"),
                                          ),
                                          DataCell(
                                            Text(
                                              player.holeThru?.toString() ??
                                                  "0",
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              player.totalGross?.toString() ??
                                                  "0",
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              player.totalNet?.toStringAsFixed(
                                                    2,
                                                  ) ??
                                                  "0.0",
                                            ),
                                          ),
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

                    /// PAGINATION
                    // const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, size: 16),
                            onPressed: currentPage > 1
                                ? () {
                                    setState(() => currentPage--);
                                    _bloc.add(
                                      FetchLeaderboardScreenEvent(currentPage),
                                    );
                                  }
                                : null,
                          ),
                          ...List.generate(totalPages, (index) {
                            final page = index + 1;
                            final isActive = page == currentPage;
                            return GestureDetector(
                              onTap: () {
                                setState(() => currentPage = page);
                                _bloc.add(
                                  FetchLeaderboardScreenEvent(currentPage),
                                );
                              },
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
                                      ? ColorConstants.green
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
                            icon: const Icon(Icons.arrow_forward_ios, size: 16),
                            onPressed: currentPage < totalPages
                                ? () {
                                    setState(() => currentPage++);
                                    _bloc.add(
                                      FetchLeaderboardScreenEvent(currentPage),
                                    );
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ),

                    // const SizedBox(height: 12),
                  ],
                );
              } else if (state is LeaderboardScreenError) {
                return Center(
                  child: Text(
                    "Error: ${state.message}",
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else {
                return const Center(child: Text("No data available"));
              }
            },
          ),
        ),
      ),
    );
  }
}
