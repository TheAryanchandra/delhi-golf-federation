import 'package:delhi_golf_federation/bloc/eventdetails/bloc/eventdetails_bloc.dart';
import 'package:delhi_golf_federation/bloc/eventdetails/bloc/eventdetails_event.dart';
import 'package:delhi_golf_federation/bloc/eventdetails/bloc/eventdetails_state.dart';
import 'package:delhi_golf_federation/data/eventdetails_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/color_constants.dart';

class EventDetailsScreen extends StatelessWidget {
  final String refNo;

  const EventDetailsScreen({super.key, required this.refNo});

  @override
  Widget build(BuildContext context) {
    final mainColor = ColorConstants.buttonColor;

    return BlocProvider(
      create: (_) =>
          EventDetailsBloc(EventDetailsRepository())
            ..add(FetchEventDetailsEvent(refNo)),
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: mainColor,
          centerTitle: true,
          title: const Text(
            'Event Details',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<EventDetailsBloc, EventDetailsState>(
          builder: (context, state) {
            if (state is EventDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EventDetailsError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else if (state is EventDetailsLoaded) {
              final details = state.eventDetails.response?.dataList?.first;
              if (details == null) {
                return const Center(child: Text('No event details found.'));
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Event Banner
                    Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: mainColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        image:
                            (details.image != null && details.image!.isNotEmpty)
                            ? DecorationImage(
                                image: NetworkImage(details.image!),
                                fit: BoxFit.cover,
                              )
                            : const DecorationImage(
                                image: AssetImage(
                                  'assets/images/golf_placeholder.jpg',
                                ),
                                fit: BoxFit.cover,
                              ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          details.eventName ?? 'Unnamed Event',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Event Info Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              "Event Type",
                              details.eventType ?? 'N/A',
                              mainColor,
                            ),
                            const Divider(),
                            _buildInfoRow(
                              "Event Date",
                              "${details.startDate ?? ''} - ${details.endDate ?? ''}",
                              mainColor,
                            ),
                            const Divider(),
                            _buildInfoRow(
                              "Venue",
                              details.venue ?? 'N/A',
                              mainColor,
                            ),
                            const Divider(),
                            _buildInfoRow(
                              "Registration Period",
                              "${details.regStartDate ?? ''} - ${details.regEndDate ?? ''}",
                              mainColor,
                            ),
                            const Divider(),
                            _buildInfoRow(
                              "Status",
                              (details.isRegistrationActive == "1")
                                  ? "Open"
                                  : "Closed",
                              mainColor,
                            ),
                            if (details.priceMoney != null &&
                                details.priceMoney!.isNotEmpty) ...[
                              const Divider(),
                              _buildInfoRow(
                                "Prize Money",
                                details.priceMoney!,
                                mainColor,
                              ),
                            ],
                            const Divider(),
                            _buildInfoRow(
                              "Year",
                              details.year ?? 'N/A',
                              mainColor,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Event Description
                    const Text(
                      "About the Event",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.buttonColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      details.content?.isNotEmpty == true
                          ? details.content!
                          : "No description available for this event.",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade800,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// Register Button
                    if (details.isRegistrationActive == "1")
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Registration started! (Coming soon...)',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          icon: const Icon(
                            Icons.app_registration,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Register Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    else
                      Center(
                        child: Text(
                          "Registration Closed",
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, Color mainColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: mainColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
