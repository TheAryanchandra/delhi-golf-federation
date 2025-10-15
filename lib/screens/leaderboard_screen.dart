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
  final int pageSize = 5; // Constant as per API

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
                return const Center(child: CircularProgressIndicator(color: ColorConstants.green));
              } else if (state is LeaderboardScreenLoaded) {
                final data = state.leaderboardData;
                final players = data.response?.players ?? [];
                final totalPages = data.response?.totalPage ?? 1;

                return Column(
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.emoji_events, color: ColorConstants.green, size: 28),
                        SizedBox(width: 10),
                        Text(
                          "LEADERBOARD",
                          style: TextStyle(
                            color: ColorConstants.green,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// TABLE VIEW
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                  constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                                  child: DataTable(
                                    headingRowColor: MaterialStateProperty.all(ColorConstants.green),
                                    headingTextStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                    dataTextStyle: const TextStyle(
                                      color: ColorConstants.darkGray,
                                      fontSize: 13,
                                    ),
                                    columnSpacing: 16,
                                    horizontalMargin: 12,
                                    dividerThickness: 1,
                                    border: TableBorder.all(color: ColorConstants.green, width: 1),
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
                                    rows: List.generate(players.length, (index) {
                                      final player = players[index];
                                      final todayValue = player.today?.toString() ?? "0";
                                      final todayColor = todayValue.startsWith('-')
                                          ? ColorConstants.redAccent
                                          : ColorConstants.darkGray;

                                      return DataRow(
                                        color: MaterialStateProperty.all(
                                          index % 2 == 0 ? ColorConstants.lightGray : Colors.white,
                                        ),
                                        cells: [
                                          DataCell(Text("${index + 1}")),
                                          DataCell(Text(player.stateName ?? "", style: const TextStyle(fontSize: 16))),
                                          DataCell(Text(player.playerName ?? "", style: const TextStyle(fontWeight: FontWeight.bold))),
                                          DataCell(Text(player.score?.toString() ?? "0", style: const TextStyle(color: ColorConstants.redAccent))),
                                          DataCell(Text(todayValue, style: TextStyle(color: todayColor, fontWeight: FontWeight.bold))),
                                          DataCell(Text(player.r1?.toString() ?? "0")),
                                          DataCell(Text(player.r2?.toString() ?? "0")),
                                          DataCell(Text(player.r3?.toString() ?? "0")),
                                          DataCell(Text(player.r4?.toString() ?? "0")),
                                          DataCell(Text(player.holeThru?.toString() ?? "0")),
                                          DataCell(Text(player.totalGross?.toString() ?? "0")),
                                          DataCell(Text(player.totalNet?.toStringAsFixed(2) ?? "0.0")),
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
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: currentPage > 1 ? _previousPage : null,
                          icon: const Icon(Icons.arrow_back_ios, color: ColorConstants.green),
                        ),
                        Text(
                          "Page $currentPage of $totalPages",
                          style: const TextStyle(
                              color: ColorConstants.darkGray,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                        IconButton(
                          onPressed: currentPage < totalPages
                              ? () => _nextPage(totalPages)
                              : null,
                          icon: const Icon(Icons.arrow_forward_ios, color: ColorConstants.green),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              } else if (state is LeaderboardScreenError) {
                return Center(
                  child: Text("Error: ${state.message}",
                      style: const TextStyle(color: Colors.red)),
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
