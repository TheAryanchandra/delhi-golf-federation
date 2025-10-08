
import 'package:delhi_golf_federation/bloc/event/bloc/event_bloc.dart';
import 'package:delhi_golf_federation/bloc/event/bloc/event_event.dart';
import 'package:delhi_golf_federation/bloc/event/bloc/event_state.dart';
import 'package:delhi_golf_federation/components/custombutton.dart';
import 'package:delhi_golf_federation/model/eventmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  bool showUpcoming = true;
  int currentPage = 1;
  final int itemsPerPage = 5; // PageSize is fixed as 5

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  void _fetchEvents() {
    context.read<EventsBloc>().add(
          FetchEvents(upcoming: showUpcoming, page: currentPage),
        );
  }

  void _switchTab(bool upcoming) {
    setState(() {
      showUpcoming = upcoming;
      currentPage = 1;
    });
    _fetchEvents();
  }

  void _changePage(int page) {
    setState(() => currentPage = page);
    _fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// Banner Header
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
                  height: screenHeight * 0.15,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: screenHeight * 0.15,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.35),
                ),
                const Text(
                  "Events",
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

          const SizedBox(height: 16),

          /// Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: "Upcoming Events",
                    onPressed: () => _switchTab(true),
                    backgroundColor:
                        showUpcoming ? const Color(0xFF0B592A) : Colors.white,
                    textColor:
                        showUpcoming ? Colors.white : const Color(0xFF0B592A),
                    borderRadius: 12,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: "Past Events",
                    onPressed: () => _switchTab(false),
                    backgroundColor:
                        !showUpcoming ? const Color(0xFF0B592A) : Colors.white,
                    textColor:
                        !showUpcoming ? Colors.white : const Color(0xFF0B592A),
                    borderRadius: 12,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// Events List with BlocBuilder
          Expanded(
            child: BlocBuilder<EventsBloc, EventsState>(
              builder: (context, state) {
                if (state is EventsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is EventsLoaded) {
                  final events = state.events ?? [];
                  final totalPages = state.totalPages ?? 1;

                  if (events.isEmpty) {
                    return const Center(child: Text("No events found."));
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            final EventModel event = events[index];
                            return _buildEventCard(event);
                          },
                        ),
                      ),

                      /// Pagination Controls
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios, size: 16),
                              onPressed: currentPage > 1
                                  ? () => _changePage(currentPage - 1)
                                  : null,
                            ),
                            ...List.generate(totalPages, (index) {
                              final page = index + 1;
                              final isActive = page == currentPage;
                              return GestureDetector(
                                onTap: () => _changePage(page),
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
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
                              icon:
                                  const Icon(Icons.arrow_forward_ios, size: 16),
                              onPressed: currentPage < totalPages
                                  ? () => _changePage(currentPage + 1)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (state is EventsError) {
                  return Center(
                      child: Text(state.message ?? "Failed to load events"));
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Event Card Widget
  Widget _buildEventCard(EventModel event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // Image
          if (event.image != null && event.image!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://delhigolf.org${event.image}',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 150,
                  color: Colors.grey.shade200,
                  child: const Center(child: Icon(Icons.image_not_supported)),
                ),
              ),
            ),
          const SizedBox(height: 8),
          // Event Name
          Text(
            event.eventName ?? 'No Name',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          // Event Type
          if (event.eventType != null)
            Text(
              'Type: ${event.eventType}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          const SizedBox(height: 4),
          // Dates
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Color(0xFF0B592A)),
              const SizedBox(width: 4),
              Text(
                '${event.startDate ?? ''} - ${event.endDate ?? ''}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Venue
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Color(0xFF0B592A)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  event.venue ?? 'No Venue',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Price Money
          if (event.priceMoney != null)
            Text(
              'Prize Money: ${event.priceMoney}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          const SizedBox(height: 4),
          // Year
          if (event.year != null)
            Text(
              'Year: ${event.year}',
              style: const TextStyle(fontSize: 14),
            ),
          const SizedBox(height: 4),
          // Ref No
          if (event.refNo != null)
          //   Text(
          //     'Ref No: ${event.refNo}',
          //     style: const TextStyle(fontSize: 14),
          //   ),
          // const SizedBox(height: 4),
          // Page Url
          // if (event.pageUrl != null)
          //   Text(
          //     'Page: ${event.pageUrl}',
          //     style: const TextStyle(fontSize: 14),
          //   ),
          // const SizedBox(height: 4),
          // Entry Date
          // if (event.entryDate != null)
          //   Text(
          //     'Entry Date: ${event.entryDate}',
          //     style: const TextStyle(fontSize: 14),
          //   ),
          // const SizedBox(height: 8),
          // Content
          if (event.content != null && event.content!.isNotEmpty)
            Html(
              data: event.content,
              style: {
                "body": Style(
                  fontSize: FontSize(14),
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                ),
              },
            ),
        ],
      ),
    );
  }
}
