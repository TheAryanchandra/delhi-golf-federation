import 'package:delhi_golf_federation/components/color_constants.dart';
import 'package:delhi_golf_federation/model/golf_ranking_model.dart';
import 'package:flutter/material.dart';

class AmateurEliteTable extends StatefulWidget {
  final List<GolfPlayer> players;
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const AmateurEliteTable({
    super.key,
    required this.players,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  State<AmateurEliteTable> createState() => _AmateurEliteTableState();
}

class _AmateurEliteTableState extends State<AmateurEliteTable> {
  @override
  Widget build(BuildContext context) {
    final pageItems = widget.players; // display all players from server

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Table Container
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
                            "DELHI RANK",
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

                  // Data Rows
                  Expanded(
                    child: pageItems.isEmpty
                        ? const Center(
                            child: Text(
                              "No data available",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: pageItems.length,
                            itemBuilder: (context, index) {
                              final player = pageItems[index];
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
                  onPressed: widget.currentPage > 1
                      ? () => widget.onPageChanged(widget.currentPage - 1)
                      : null,
                ),
                ...List.generate(widget.totalPages, (index) {
                  final page = index + 1;
                  final isActive = page == widget.currentPage;
                  return GestureDetector(
                    onTap: () => widget.onPageChanged(page),
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
                  onPressed: widget.currentPage < widget.totalPages
                      ? () => widget.onPageChanged(widget.currentPage + 1)
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
