import 'package:delhi_golf_federation/bloc/eventdetails/bloc/eventdetails_bloc.dart';
import 'package:delhi_golf_federation/bloc/eventdetails/bloc/eventdetails_event.dart';
import 'package:delhi_golf_federation/bloc/eventdetails/bloc/eventdetails_state.dart';
import 'package:delhi_golf_federation/data/eventdetails_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/color_constants.dart';
import 'package:flutter_html/flutter_html.dart';


class EventDetailsScreen extends StatefulWidget {
  final String refNo;

  const EventDetailsScreen({super.key, required this.refNo});

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen>
    with TickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final mainColor = ColorConstants.buttonColor;

    return BlocProvider(
      create: (_) => EventDetailsBloc(EventDetailsRepository())
        ..add(FetchEventDetailsEvent(widget.refNo)),
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: mainColor,
          elevation: 2,
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

              // Handle full image URL
              String? imageUrl = details.image;
              if (imageUrl != null && imageUrl.isNotEmpty) {
                if (!imageUrl.startsWith("http")) {
                  imageUrl = "https://delhigolf.org/$imageUrl";
                }
              }

              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Event Banner
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          Image.network(
                            imageUrl ??
                                "https://delhigolf.org/Images/Upload/FrontProfile/img_18102025125341296_e19193.png",
                            height: 230,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              'assets/images/golf_placeholder.jpg',
                              height: 230,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.7),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              child: Text(
                                details.eventName ?? 'Unnamed Event',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    /// Event Info Card
                   

                    /// About Event Section
                    const Text(
                      "About the Event",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.buttonColor,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Builder(
                      builder: (context) {
                        final content = details.content ?? "";
                        final showToggle = content.length > 300;

                        Widget htmlWidget = Html(
                          data: content.isNotEmpty
                              ? content
                              : "<p>No description available for this event.</p>",
                          style: {
                            "body": Style(
                              fontSize: FontSize(15),
                              color: Colors.grey.shade800,
                              lineHeight: LineHeight(1.5),
                              margin: Margins.zero,
                              padding: HtmlPaddings.zero, // ✅ FIXED
                            ),
                            "h3": Style(
                              fontSize: FontSize(20),
                              fontWeight: FontWeight.bold,
                            ),
                            "h4": Style(
                              fontSize: FontSize(18),
                              fontWeight: FontWeight.w600,
                            ),
                            "p": Style(margin: Margins.symmetric(vertical: 6)),
                            "ul": Style(
                              margin: Margins.symmetric(
                                vertical: 6,
                                horizontal: 12,
                              ),
                            ),
                          },
                        );

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedSize(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                child: ClipRect(
                                  child: ConstrainedBox(
                                    constraints: _isExpanded
                                        ? const BoxConstraints()
                                        : const BoxConstraints(maxHeight: 150),
                                    child: SingleChildScrollView(
                                      physics: const NeverScrollableScrollPhysics(),
                                      child: htmlWidget,
                                    ),
                                  ),
                                ),
                              ),
                              if (showToggle)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () => setState(
                                      () => _isExpanded = !_isExpanded,
                                    ),
                                    child: Text(
                                      _isExpanded ? "Read less" : "Read more",
                                      style: TextStyle(
                                        color: mainColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 35),

                    /// Register Button or Closed Label
                    // Center(
                    //   child: details.isRegistrationActive == "1"
                    //       ? ElevatedButton.icon(
                    //           onPressed: () {
                    //             ScaffoldMessenger.of(context).showSnackBar(
                    //               const SnackBar(
                    //                 content: Text(
                    //                   'Registration feature coming soon...',
                    //                 ),
                    //               ),
                    //             );
                    //           },
                    //           style: ElevatedButton.styleFrom(
                    //             backgroundColor: mainColor,
                    //             padding: const EdgeInsets.symmetric(
                    //               horizontal: 40,
                    //               vertical: 16,
                    //             ),
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(30),
                    //             ),
                    //             elevation: 3,
                    //           ),
                    //           icon: const Icon(
                    //             Icons.app_registration,
                    //             color: Colors.white,
                    //           ),
                    //           label: const Text(
                    //             "Register Now",
                    //             style: TextStyle(
                    //               color: Colors.white,
                    //               fontSize: 17,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         )
                    //       : Container(
                    //           padding: const EdgeInsets.symmetric(
                    //             horizontal: 20,
                    //             vertical: 10,
                    //           ),
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(20),
                    //             color: Colors.red.shade100,
                    //           ),
                    //           child: const Text(
                    //             "Registration Closed",
                    //             style: TextStyle(
                    //               color: Colors.red,
                    //               fontSize: 16,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         ),
                    // ),

                    const SizedBox(height: 30),
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

  Widget _buildInfoRow(String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15.5,
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
                color: color,
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
