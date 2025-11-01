import 'package:delhi_golf_federation/bloc/event/bloc/event_bloc.dart';
import 'package:delhi_golf_federation/bloc/event/bloc/event_event.dart';
import 'package:delhi_golf_federation/bloc/event/bloc/event_state.dart';
import 'package:delhi_golf_federation/bloc/getdata/bloc/getdata_bloc.dart';
import 'package:delhi_golf_federation/bloc/getdata/bloc/getdata_event.dart';
import 'package:delhi_golf_federation/components/bottomnavigation.dart';
import 'package:delhi_golf_federation/components/custombutton.dart';
import 'package:delhi_golf_federation/config/routes_name.dart';
import 'package:delhi_golf_federation/model/eventmodel.dart';
import 'package:delhi_golf_federation/widgets/eventwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  bool showUpcoming = true;
  int currentPage = 1;
  final int itemsPerPage = 5;

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
                    backgroundColor: showUpcoming
                        ? const Color(0xFF0B592A)
                        : Colors.white,
                    textColor: showUpcoming
                        ? Colors.white
                        : const Color(0xFF0B592A),
                    borderRadius: 12,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: "Past Events",
                    onPressed: () => _switchTab(false),
                    backgroundColor: !showUpcoming
                        ? const Color(0xFF0B592A)
                        : Colors.white,
                    textColor: !showUpcoming
                        ? Colors.white
                        : const Color(0xFF0B592A),
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
                    child: Text(state.message ?? "Failed to load events"),
                  );
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
    final bool isRegistrationActive =
        event.isRegistrationActive?.toLowerCase() == "true";
    final bool isEventActive = event.eventActive?.toLowerCase() == "true";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF12563C), // ✅ wrap with Color()
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Event Name
          Text(
            event.eventName ?? 'No Name',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white, // ✅ this works perfectly
            ),
          ),

          const SizedBox(height: 10),

          /// Event Dates
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.event, size: 18, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                'Event: ${event.startDate ?? ''} - ${event.endDate ?? ''}',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white, // ✅ move color inside TextStyle
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          /// Registration Dates
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.app_registration, size: 18, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                'Registration: ${event.regStartDate ?? ''} - ${event.regEndDate ?? ''}',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white, // ✅ move color inside TextStyle
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          /// Venue
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 18, color: Colors.white),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  event.venue ?? 'No Venue',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// Prize Money
          if (event.priceMoney != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.attach_money, size: 18, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  'Prize Money: ${event.priceMoney}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

          const SizedBox(height: 20),

          /// Buttons Section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // View Button
              CustomButton(
                text: "View",
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RoutesName.eventDetailsScreen,
                    arguments: {'refNo': event.refNo ?? ''},
                  );
                },
                backgroundColor: Colors.white,
                textColor: Colors.black,
                borderRadius: 10,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),

              const SizedBox(width: 12),

              if (showUpcoming)
                Builder(
                  builder: (context) {
                    if (isRegistrationActive) {
                      // ✅ Registration Active → Check payment mode before popup
                      return ElevatedButton(
                        onPressed: () {
                          final paymentMode =
                              event.paymentMode?.toLowerCase() ?? 'un paid';

                          if (paymentMode == 'un paid') {
                            // 🔹 Show payment popup or navigate to Razorpay screen
                            showDialog(
                              context: context,
                              builder: (context) => const PaymentPopup(),
                            );
                          } else if (paymentMode == 'paid') {
                            // 🔹 Directly open registration popup
                            context.read<UserDataBloc>().add(
                              FetchUserDataEvent(),
                            );
                            showDialog(
                              context: context,
                              builder: (context) => EventRegisterPopup(
                                eventRefNo: event.refNo ?? '',
                                price: event.price ?? 0.0,
                              ),
                            );
                          } else {
                            // 🔹 fallback
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Invalid Payment Mode'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      );
                    } else {
                      // ✅ Either Event Active OR Registration Closed → Leaderboard button
                      return CustomButton(
                        text: "Leaderboard",
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CustomBottomNav(initialIndex: 1),
                            ),
                            (route) => false,
                          );
                        },
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        borderRadius: 10,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      );
                    }
                  },
                )
              else
                // ✅ For Past Events → Always show Leaderboard
                CustomButton(
                  text: "Leaderboard",
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const CustomBottomNav(initialIndex: 1),
                      ),
                      (route) => false,
                    );
                  },
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  borderRadius: 10,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Payment Popup Widget
class PaymentPopup extends StatelessWidget {
  const PaymentPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Complete Payment'),
      content: const Text(
        'Please complete your payment to register for this event.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            // 🔹 Proceed to Razorpay payment screen or logic
            // e.g., Navigator.pushNamed(context, RoutesName.paymentScreen);
          },
          child: const Text('Pay Now'),
        ),
      ],
    );
  }
}
