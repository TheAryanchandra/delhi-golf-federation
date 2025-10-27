// lib/screens/eventreport_screen.dart

import 'package:delhi_golf_federation/model/eventreportmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:delhi_golf_federation/components/bottomnavigation.dart';
import 'package:delhi_golf_federation/components/color_constants.dart';
import 'package:delhi_golf_federation/components/custombutton.dart';
import 'package:delhi_golf_federation/config/routes_name.dart';
import 'package:delhi_golf_federation/screens/eventscorecard.dart';

// BLoC & model imports — adjust paths if your project uses different folders:
import 'package:delhi_golf_federation/bloc/eventreport/bloc/eventreport_bloc.dart';
import 'package:delhi_golf_federation/bloc/eventreport/bloc/eventreport_event.dart';
import 'package:delhi_golf_federation/bloc/eventreport/bloc/eventreport_state.dart';

class EventReportScreen extends StatefulWidget {
  const EventReportScreen({super.key});

  @override
  State<EventReportScreen> createState() => _EventReportScreenState();
}

class _EventReportScreenState extends State<EventReportScreen> {
  bool showCurrent = true;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    // fetch events after the first frame so context.read is available
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchEvents());
  }

  void _fetchEvents({int page = 1}) {
    currentPage = page;
    final request = EventReportRequest(page: currentPage, pageSize: 5);

    // dispatch the correct event class (FetchEventReport)
    context.read<EventReportBloc>().add(
      FetchEventReport(request: request, isCurrent: showCurrent),
    );
  }

  void _switchTab(bool current) {
    if (showCurrent == current) return;
    setState(() {
      showCurrent = current;
      currentPage = 1;
    });
    _fetchEvents(page: 1);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Image
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
                  color: Colors.black.withOpacity(0.35),
                ),
                const Text(
                  "Scorecards",
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

          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: "Current Scorecards",
                    onPressed: () => _switchTab(true),
                    backgroundColor: showCurrent
                        ? const Color(0xFF0B592A)
                        : Colors.white,
                    textColor: showCurrent
                        ? Colors.white
                        : const Color(0xFF0B592A),
                    borderRadius: 12,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: "Past Scorecards",
                    onPressed: () => _switchTab(false),
                    backgroundColor: !showCurrent
                        ? const Color(0xFF0B592A)
                        : Colors.white,
                    textColor: !showCurrent
                        ? Colors.white
                        : const Color(0xFF0B592A),
                    borderRadius: 12,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
          ),

          // Event List (Bloc-driven)
          Expanded(
            child: BlocBuilder<EventReportBloc, EventReportState>(
              builder: (context, state) {
                if (state is EventReportLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is EventReportError) {
                  return Center(child: Text("Error: ${state.message}"));
                }

                if (state is EventReportLoaded) {
                  // state.response is EventReportResponse
                  final response = state.response;
                  final events = response.response?.dt ?? <EventData>[];
                  final totalPages = response.response?.totalPage ?? 1;

                  if (events.isEmpty) {
                    return const Center(
                      child: Text(
                        "No events found.",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8,
                          ),
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            final event = events[index];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF12563C,
                                ), // ✅ wrap with Color()
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade300),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 6,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      event.eventName ?? "Unnamed Event",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildInfoRow(
                                    Icons.calendar_today,
                                    "Event: ${_formatDateRange(event.startDate, event.endDate)}",
                                  ),
                                  _buildInfoRow(
                                    Icons.event_available,
                                    "Registration: ${_formatDateRange(event.regStartDate, event.regEndDate)}",
                                  ),
                                  _buildInfoRow(
                                    Icons.location_on,
                                    event.venue ?? "Venue not available",
                                  ),
                                  _buildInfoRow(
                                    Icons.attach_money,
                                    "Prize Money: ${event.priceMoney?.isEmpty ?? true ? 'N/A' : event.priceMoney}",
                                  ),
                                  const SizedBox(height: 16),

                                  // Buttons
                                  Row(
                                    children: [
                                      if (showCurrent) ...[
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EventScorecardScreen(
                                                        regRefNo:
                                                            event.regRefNo ??
                                                            "",
                                                        courseRefNo:
                                                            event.courseRefNo ??
                                                            "",
                                                        eventRefNo:
                                                            event.refNo ?? "",
                                                        eventStartDate:
                                                            event.startDate ??
                                                            "", // <-- start date
                                                        eventEndDate:
                                                            event.endDate ?? "",
                                                        handicapStatus:
                                                            event.handicap ??
                                                            "",
                                                      ),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                               backgroundColor: const Color(0xFF0B592A),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                  ),
                                            ),
                                            child: const Text(
                                              "Add Score",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                context,
                                                RoutesName.viewScoreScreen,
                                                arguments: {
                                                  'eventRefNo':
                                                      event.refNo ?? '',
                                                },
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF0B592A),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                  ),
                                            ),
                                            child: const Text(
                                              "View Score",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ] else ...[
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const CustomBottomNav(
                                                        initialIndex: 1,
                                                      ),
                                                ),
                                                (route) => false,
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  ColorConstants.buttonColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                  ),
                                            ),
                                            child: const Text(
                                              "Leaderboard",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      // Pagination controls
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // ElevatedButton(
                            //   onPressed: currentPage > 1
                            //       ? () {
                            //           _fetchEvents(page: currentPage - 1);
                            //         }
                            //       : null,
                            //   style: ElevatedButton.styleFrom(
                            //     backgroundColor: ColorConstants.buttonColor,
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(8),
                            //     ),
                            //     padding: const EdgeInsets.symmetric(
                            //       horizontal: 16,
                            //       vertical: 12,
                            //     ),
                            //   ),
                            //   child: const Text(
                            //     "Previous",
                            //     style: TextStyle(color: Colors.white),
                            //   ),
                            // ),
                            // Text("Page $currentPage of $totalPages"),
                            // ElevatedButton(
                            //   onPressed: currentPage < totalPages
                            //       ? () {
                            //           _fetchEvents(page: currentPage + 1);
                            //         }
                            //       : null,
                            //   style: ElevatedButton.styleFrom(
                            //     backgroundColor: ColorConstants.buttonColor,
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(8),
                            //     ),
                            //     padding: const EdgeInsets.symmetric(
                            //       horizontal: 16,
                            //       vertical: 12,
                            //     ),
                            //   ),
                            //   child: const Text(
                            //     "Next",
                            //     style: TextStyle(color: Colors.white),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                // initial / fallback
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  String _formatDateRange(String? start, String? end) {
    if (start == null || end == null) return "N/A";
    final startDate = DateTime.tryParse(start);
    final endDate = DateTime.tryParse(end);
    if (startDate == null || endDate == null) return "N/A";
    return "${_formatDate(startDate)} - ${_formatDate(endDate)}";
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)} ${date.year % 100}";
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
