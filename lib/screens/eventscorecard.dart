import 'package:delhi_golf_federation/bloc/insertscore/bloc/insertscore_bloc.dart';
import 'package:delhi_golf_federation/bloc/insertscore/bloc/insertscore_event.dart';
import 'package:delhi_golf_federation/bloc/insertscore/bloc/insertscore_state.dart';
import 'package:delhi_golf_federation/bloc/scorecard/bloc/scorecard_bloc.dart';
import 'package:delhi_golf_federation/bloc/scorecard/bloc/scorecard_event.dart';
import 'package:delhi_golf_federation/bloc/scorecard/bloc/scorecard_state.dart';
import 'package:delhi_golf_federation/components/custombutton.dart';
import 'package:delhi_golf_federation/config/routes_name.dart';
import 'package:delhi_golf_federation/model/insertscore_model.dart';
import 'package:delhi_golf_federation/model/scorecard_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EventScorecardScreen extends StatefulWidget {
  final String regRefNo;
  final String courseRefNo;
  final String eventRefNo;
  final String eventStartDate; // "yyyy-MM-dd" or format your API returns
  final String eventEndDate;

  const EventScorecardScreen({
    super.key,
    required this.regRefNo,
    required this.courseRefNo,
    required this.eventRefNo,
    required this.eventStartDate,
    required this.eventEndDate,
  });

  @override
  State<EventScorecardScreen> createState() => _EventScorecardScreenState();
}

class _EventScorecardScreenState extends State<EventScorecardScreen> {
  List<HoleInfo> holes = [];
  PlayerInfo? playerInfo;
  final PageController _pageController = PageController();
  final Map<int, TextEditingController> _scoreControllers = {};
  int currentHoleIndex = 0;
  DateTime selectedDate = DateTime.now(); // default current date

  late DateTime regStartDateTime;
  late DateTime regEndDateTime;

  @override
  void initState() {
    super.initState();

    regStartDateTime =
        DateTime.tryParse(widget.eventStartDate) ?? DateTime.now();
    regEndDateTime = DateTime.tryParse(widget.eventEndDate) ?? DateTime.now();

    // Ensure selectedDate is within the interval
    selectedDate = DateTime.now().isBefore(regStartDateTime)
        ? regStartDateTime
        : DateTime.now().isAfter(regEndDateTime)
        ? regEndDateTime
        : DateTime.now();

    context.read<EventScoreBloc>().add(
      FetchEventScore(
        request: EventScoreRequest(
          eventRefNo: widget.eventRefNo,
          regEventRefNo: widget.regRefNo,
          courseRefNo: widget.courseRefNo,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int get totalScore => holes.fold(0, (sum, hole) => sum + (hole.score ?? 0));

  // Function to submit current hole's score
  void _submitCurrentHole(HoleInfo hole, {bool finalSubmit = false}) {
    final request = LeaderboardRequest(
      id: 0,
      stateName: "",
      playerName: playerInfo?.name ?? 'Unknown',
      dates: hole.playedDate != null
          ? DateFormat('dd/MM/yyyy').format(hole.playedDate!)
          : DateFormat('dd/MM/yyyy').format(DateTime.now()),
      handicap: playerInfo?.usgaHandicapIndex?.toInt() ?? 0,
      score: hole.score ?? 0,
      today: hole.score ?? 0,
      extraPoint: 0,
      dayScore: hole.par ?? 0,
      holeThru: hole.hole ?? 0,
      par: hole.par ?? 0, // <-- added
      indexs: hole.indexNo ?? 0, // <-- added
      totalGross: 0,
      totalNet: 0,
      courseRefNo: widget.courseRefNo,
      eventRefNo: widget.eventRefNo,
      eventRegNo: widget.regRefNo,
      finalSubmit: currentHoleIndex == holes.length - 1,
    );

    debugPrint("Sending LeaderboardRequest: $request");

    context.read<LeaderboardBloc>().add(SubmitLeaderboard(request: request));
  }

  // Add new method to calculate adjusted score
  int calculateAdjustedScore(HoleInfo hole) {
    final handicap = playerInfo?.usgaHandicapIndex?.toInt() ?? 0;
    final holeIndex = hole.indexNo ?? 0;
    final inputScore = hole.score ?? 0;
    final par = hole.par ?? 0;

    if (holeIndex <= handicap) {
      return inputScore - (par + 1);
    }
    return inputScore - par;
  }

  int cumulativeScore(int upToHoleIndex) {
    int sum = 0;
    for (int i = 0; i <= upToHoleIndex; i++) {
      final hole = holes[i];
      if (hole.score != null) {
        sum += calculateAdjustedScore(hole);
      }
    }
    return sum;
  }

  // Modify date picker to reset scores
  void _updatePlayingDate(DateTime picked) {
    setState(() {
      selectedDate = picked;

      // Reset all scores and update playedDate
      for (var i = 0; i < holes.length; i++) {
        holes[i].playedDate = picked;
        holes[i].score = null;

        // Also clear the corresponding TextEditingController
        if (_scoreControllers.containsKey(i)) {
          _scoreControllers[i]!.text = '';
        }
      }

      // Reset to first hole
      currentHoleIndex = 0;
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  // Add validation method
  bool _validateCurrentHole() {
    final currentHole = holes[currentHoleIndex];
    if (currentHole.score == null || currentHole.score == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter score for Hole ${currentHole.hole}'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF12563C);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: mainColor),
        title: const Text(
          "Event Scorecard",
          style: TextStyle(
            color: mainColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocListener<LeaderboardBloc, LeaderboardState>(
          listener: (context, state) {
            if (state is LeaderboardLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );
            } else {
              Navigator.of(context, rootNavigator: true).pop();

              if (state is LeaderboardSuccess) {
                debugPrint("Received response: ${state.response}");

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.response.message ?? 'Score submitted!'),
                  ),
                );

                // Navigate only if final submit
                if (currentHoleIndex == holes.length - 1) {
                  Navigator.pushNamed(context, RoutesName.confirmUploadScore);
                }
              } else if (state is LeaderboardError) {
                debugPrint("Error: ${state.message}");

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.message}')),
                );
              }
            }
          },
          child: BlocBuilder<EventScoreBloc, EventScoreState>(
            builder: (context, state) {
              if (state is EventScoreLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is EventScoreError) {
                return Center(child: Text("Error: ${state.message}"));
              } else if (state is EventScoreLoaded) {
                if (holes.isEmpty) {
                  holes = state.response.ds?.table2 ?? [];
                  playerInfo = state.response.ds?.table1?.first;

                  // Initialize all holes with the selectedDate
                  for (var hole in holes) {
                    hole.playedDate = selectedDate;
                  }
                }

                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      // Player Info
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: mainColor.withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              playerInfo?.courseName ??
                                  "Delhi Golf Championship 2025",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: mainColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Player: ${playerInfo?.name ?? 'Unknown'}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  "Handicap: ${playerInfo?.usgaHandicapIndex?.toStringAsFixed(1) ?? '0'}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Playing Date:",
                                  style: TextStyle(fontSize: 16),
                                ),
                                InkWell(
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate:
                                          selectedDate, // use single selectedDate
                                      firstDate: regStartDateTime,
                                      lastDate: regEndDateTime,
                                    );
                                    if (picked != null &&
                                        picked != selectedDate) {
                                      _updatePlayingDate(picked);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: mainColor.withOpacity(0.4),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          color: mainColor,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          DateFormat(
                                            'dd/MM/yyyy',
                                          ).format(selectedDate),

                                          // style: TextStyle(
                                          //   color:
                                          //       holes.isNotEmpty &&
                                          //           holes[currentHoleIndex]
                                          //                   .playedDate !=
                                          //               null
                                          //       ? Colors.black
                                          //       : Colors.grey.shade600,
                                          //   fontSize: 15,
                                          // ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Hole Selector Scroll
                      SizedBox(
                        height: 60,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: holes.length,
                          itemBuilder: (context, index) {
                            final isSelected = index == currentHoleIndex;
                            return GestureDetector(
                              onTap: () {
                                if (index > currentHoleIndex &&
                                    !_validateCurrentHole()) {
                                  // Trying to go forward without entering score
                                  return;
                                }
                                if (index <= currentHoleIndex) {
                                  // Can go to previous hole freely
                                  setState(() {
                                    currentHoleIndex = index;
                                  });
                                  _pageController.animateToPage(
                                    index,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },

                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected ? mainColor : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? mainColor
                                        : mainColor.withOpacity(0.3),
                                  ),
                                  boxShadow: [
                                    if (isSelected)
                                      BoxShadow(
                                        color: mainColor.withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    "Hole ${holes[index].hole ?? 0}",
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : mainColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Hole Detail PageView
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.40,
                        child: PageView.builder(
                          controller: _pageController,
                          physics:
                              const NeverScrollableScrollPhysics(), // Disable swipe
                          onPageChanged: (index) {
                            setState(() {
                              currentHoleIndex = index;
                            });
                          },
                          itemCount: holes.length,
                          itemBuilder: (context, index) {
                            final hole = holes[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: mainColor.withOpacity(0.2),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12.withOpacity(0.08),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        "Hole ${hole.hole ?? 0}",
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: mainColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     const Text(
                                    //       "Playing Date:",
                                    //       style: TextStyle(fontSize: 16),
                                    //     ),
                                    //     InkWell(
                                    //       onTap: () async {
                                    //         final picked = await showDatePicker(
                                    //           context: context,
                                    //           initialDate:
                                    //               hole.playedDate ??
                                    //               DateTime.now(),
                                    //           firstDate: DateTime(2020),
                                    //           lastDate: DateTime(2030),
                                    //         );
                                    //         if (picked != null) {
                                    //           setState(() {
                                    //             hole.playedDate = picked;
                                    //           });
                                    //         }
                                    //       },
                                    //       child: Container(
                                    //         padding: const EdgeInsets.symmetric(
                                    //           horizontal: 12,
                                    //           vertical: 8,
                                    //         ),
                                    //         decoration: BoxDecoration(
                                    //           color: Colors.grey.shade100,
                                    //           borderRadius:
                                    //               BorderRadius.circular(8),
                                    //           border: Border.all(
                                    //             color: mainColor.withOpacity(
                                    //               0.4,
                                    //             ),
                                    //           ),
                                    //         ),
                                    //         child: Row(
                                    //           children: [
                                    //             const Icon(
                                    //               Icons.calendar_today,
                                    //               color: mainColor,
                                    //               size: 18,
                                    //             ),
                                    //             const SizedBox(width: 8),
                                    //             Text(
                                    //               hole.playedDate != null
                                    //                   ? DateFormat(
                                    //                       'dd/MM/yyyy',
                                    //                     ).format(
                                    //                       hole.playedDate!,
                                    //                     )
                                    //                   : "Select Date",
                                    //               style: TextStyle(
                                    //                 color:
                                    //                     hole.playedDate != null
                                    //                     ? Colors.black
                                    //                     : Colors.grey.shade600,
                                    //                 fontSize: 15,
                                    //               ),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Par: ${hole.par}",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          "Index: ${hole.indexNo}",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          cumulativeScore(index) == 0
                                              ? "Enter score"
                                              : "Score: ${cumulativeScore(index)}",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      controller: _scoreControllers.putIfAbsent(
                                        index,
                                        () => TextEditingController(
                                          text: hole.score?.toString() ?? '',
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        labelText: "Enter Score",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: mainColor,
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      onChanged: (val) {
                                        setState(() {
                                          hole.score = int.tryParse(val);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Next / Submit Button
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: SafeArea(
                          child: SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              text: currentHoleIndex == holes.length - 1
                                  ? "Submit"
                                  : "Next Hole",
                              backgroundColor: mainColor,
                              onPressed: () {
                                if (!_validateCurrentHole()) return;

                                final currentHole = holes[currentHoleIndex];

                                // Calculate adjusted score before submitting
                                final adjustedScore = calculateAdjustedScore(
                                  currentHole,
                                );

                                debugPrint(
                                  "Submitting hole ${currentHole.hole} with adjusted score: $adjustedScore",
                                );

                                _submitCurrentHole(
                                  currentHole,
                                  finalSubmit:
                                      currentHoleIndex == holes.length - 1,
                                );

                                if (currentHoleIndex < holes.length - 1) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                  setState(() => currentHoleIndex++);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
