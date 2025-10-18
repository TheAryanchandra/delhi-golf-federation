import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:delhi_golf_federation/bloc/viewscore/bloc/viewscore_bloc.dart';
import 'package:delhi_golf_federation/bloc/viewscore/bloc/viewscore_event.dart';
import 'package:delhi_golf_federation/bloc/viewscore/bloc/viewscore_state.dart';
import 'package:delhi_golf_federation/data/viewscore_repository.dart';

class EventScoreViewScreen extends StatefulWidget {
  final String eventRefNo;

  const EventScoreViewScreen({super.key, required this.eventRefNo});

  @override
  State<EventScoreViewScreen> createState() => _EventScoreViewScreenState();
}

class _EventScoreViewScreenState extends State<EventScoreViewScreen> {
  static const mainColor = Color(0xFF12563C);
  DateTime selectedDate = DateTime.now();
  String eventRefNo = '';
  late final ViewScoreBloc _viewScoreBloc;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _viewScoreBloc = ViewScoreBloc(ViewScoreRepository());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      eventRefNo = widget.eventRefNo;
      _fetchData();
      _initialized = true;
    }
  }

  void _fetchData() {
    final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
    _viewScoreBloc.add(
      FetchViewScoreEvent(date: formattedDate, eventRefNo: eventRefNo),
    );
  }

  @override
  void dispose() {
    _viewScoreBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _viewScoreBloc,
      child: BlocBuilder<ViewScoreBloc, ViewScoreState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              backgroundColor: mainColor,
              centerTitle: true,
              title: const Text(
                "Event Scorecard",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Column(
              children: [
                // Date Picker
                Container(
                  color: mainColor.withOpacity(0.1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Select Date:",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: mainColor,
                          fontSize: 16,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setState(() => selectedDate = picked);
                            _fetchData();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                DateFormat('dd MMM yyyy').format(selectedDate),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Builder(
                    builder: (_) {
                      if (state is ViewScoreLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: mainColor),
                        );
                      } else if (state is ViewScoreError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      } else if (state is ViewScoreLoaded) {
                        final items = state.data.response?.dt ?? [];
                        if (items.isEmpty) {
                          return const Center(
                            child: Text("No scores available"),
                          );
                        }

                        items.sort(
                          (a, b) =>
                              (a.holeThru ?? 0).compareTo(b.holeThru ?? 0),
                        );

                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                color: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                child: Text(
                                  items.first.eventName ??
                                      "-", // using first item's eventName
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: mainColor,
                                  ),
                                ),
                              ),
                              // Table Header
                              Container(
                                color: mainColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: const [
                                    // Expanded(
                                    //   child: Text(
                                    //     "Score",
                                    //     textAlign: TextAlign.center,
                                    //     style: TextStyle(
                                    //       color: Colors.white,
                                    //       fontWeight: FontWeight.bold,
                                    //     ),
                                    //   ),
                                    // ),
                                    Expanded(
                                      child: Text(
                                        "Hole",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Par",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Index",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                      Expanded(
                                      child: Text(
                                        "Score",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Points",
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

                              // Table Rows
                              ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: items.length,
                                separatorBuilder: (_, __) =>
                                    Divider(color: Colors.grey.shade300),
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  final points = item.points ?? 0;

                                  Color pointsColor = points < 0
                                      ? const Color.fromARGB(255, 246, 1, 1)
                                      : (points > 0
                                            ? const Color.fromARGB(
                                                255,
                                                13,
                                                13,
                                                13,
                                              )
                                            : const Color.fromARGB(
                                                255,
                                                7,
                                                7,
                                                7,
                                              ));

                                  Color rowColor = index % 2 == 0
                                      ? Colors.grey.shade100
                                      : Colors.white;

                                  return Container(
                                    color: rowColor,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                      horizontal: 8,
                                    ),
                                    child: Row(
                                      children: [
                                        //  Expanded(
                                        //   child: Text(
                                        //     "${item.score}",
                                        //     textAlign: TextAlign.center,
                                        //     style: const TextStyle(
                                        //       color: mainColor,
                                        //     ),
                                        //   ),
                                        // ),
                                        Expanded(
                                          child: Text(
                                            "${item.holeThru}",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: mainColor,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${item.par}",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: mainColor,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${item.indexs}",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: mainColor,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${item.score}",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: mainColor,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "$points",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: pointsColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
