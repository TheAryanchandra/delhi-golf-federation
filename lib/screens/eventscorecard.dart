import 'package:delhi_golf_federation/bloc/scorecard/bloc/scorecard_bloc.dart';
import 'package:delhi_golf_federation/bloc/scorecard/bloc/scorecard_event.dart';
import 'package:delhi_golf_federation/bloc/scorecard/bloc/scorecard_state.dart';
import 'package:delhi_golf_federation/components/custombutton.dart';
import 'package:delhi_golf_federation/config/routes_name.dart';
import 'package:delhi_golf_federation/model/scorecard_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';


class EventScorecardScreen extends StatefulWidget {
  final String regRefNo;
  final String courseRefNo;
  final String eventRefNo;

  const EventScorecardScreen({
    super.key,
    required this.regRefNo,
    required this.courseRefNo,
    required this.eventRefNo,
  });

  @override
  State<EventScorecardScreen> createState() => _EventScorecardScreenState();
}

class _EventScorecardScreenState extends State<EventScorecardScreen> {
  List<HoleInfo> holes = [];
  PlayerInfo? playerInfo;
  final PageController _pageController = PageController();
  int currentHoleIndex = 0;

  @override
  void initState() {
    super.initState();
    print('regRefNo: ${widget.regRefNo}');
    print('courseRefNo: ${widget.courseRefNo}');
    print('eventRefNo: ${widget.eventRefNo}');
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
  int get totalPar => holes.fold(0, (sum, hole) => sum + (hole.par ?? 0));

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
              }

              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // 🏌️‍♂️ Player Info
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
                            playerInfo?.courseName ?? "Delhi Golf Championship 2025",
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // 🎯 Hole Selector Scroll
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
                              setState(() {
                                currentHoleIndex = index;
                              });
                              _pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(horizontal: 6),
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
                                  "Hole ${holes[index].hole}",
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : mainColor,
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
                    // 📄 Hole Detail View
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.55,
                      child: PageView.builder(
                        controller: _pageController,
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
                                border:
                                    Border.all(color: mainColor.withOpacity(0.2)),
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
                                      "Hole ${hole.hole}",
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: mainColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // 🗓️ Date Selector
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                                hole.playedDate ?? DateTime.now(),
                                            firstDate: DateTime(2020),
                                            lastDate: DateTime(2030),
                                          );
                                          if (picked != null) {
                                            setState(() {
                                              hole.playedDate = picked;
                                            });
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color:
                                                    mainColor.withOpacity(0.4)),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.calendar_today,
                                                  color: mainColor, size: 18),
                                              const SizedBox(width: 8),
                                              Text(
                                                hole.playedDate != null
                                                    ? DateFormat('dd/MM/yyyy')
                                                        .format(
                                                            hole.playedDate!)
                                                    : "Select Date",
                                                style: TextStyle(
                                                  color: hole.playedDate != null
                                                      ? Colors.black
                                                      : Colors.grey.shade600,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

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
                                        "Score: ${hole.score ?? 0}",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    initialValue: (hole.score ?? 0).toString(),
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      labelText: "Enter Score",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                                        hole.score = int.tryParse(val) ?? 0;
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
                    // 🔘 Next / Submit Button
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
                              if (currentHoleIndex < holes.length - 1) {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                final holeData =
                                    holes.map((hole) => hole.toJson()).toList();

                                Navigator.pushNamed(
                                  context,
                                  RoutesName.confirmUploadScore,
                                  arguments: holeData,
                                );
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
    );
  }
}
