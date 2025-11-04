import 'package:delhi_golf_federation/components/custombutton.dart';
import 'package:flutter/material.dart';
import 'package:delhi_golf_federation/services/navigation_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:delhi_golf_federation/bloc/event/bloc/event_bloc.dart';
import 'package:delhi_golf_federation/bloc/event/bloc/event_event.dart';
import 'package:delhi_golf_federation/bloc/event/bloc/event_state.dart';
import 'package:delhi_golf_federation/model/eventmodel.dart';
import 'package:delhi_golf_federation/config/routes_name.dart';

/// Sponsors Section
class SponsorsSection extends StatelessWidget {
  const SponsorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Text(
            "Our Sponsors",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B592A),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              SponsorCard(
                imgPath: "assets/images/Gold partner.png",
                title: "Gold Partner",
              ),
              SponsorCard(
                imgPath: "assets/images/Silver partner.png",
                title: "Silver Partner",
              ),
              SponsorCard(
                imgPath: "assets/images/bronze partner.png",
                title: "Bronze Partner",
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SponsorCard extends StatelessWidget {
  final String imgPath;
  final String title;

  const SponsorCard({super.key, required this.imgPath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(imgPath, height: 80, fit: BoxFit.cover),
          ),
          // const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

/// Golf Club Facilities Section
class GolfClubFacilities extends StatelessWidget {
  const GolfClubFacilities({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            "Our Golf Federation Facilities",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B592A),
            ),
          ),
        ),
        const SizedBox(height: 12),

        /// Row with horizontal scrolling
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: const [
                FacilityCard(
                  imgPath: "assets/images/golfstick.png",
                  title: "Practice Ranges",
                ),
                SizedBox(width: 8), // reduced gap
                FacilityCard(
                  imgPath: "assets/images/golfperson.png",
                  title: "Youth Training\nPrograms",
                ),
                SizedBox(width: 8),
                FacilityCard(
                  imgPath: "assets/images/event venues.png",
                  title: "Event Venues",
                ),
                SizedBox(width: 8),
                FacilityCard(
                  imgPath: "assets/images/community programs.png",
                  title: "Community\nPrograms",
                ),
                SizedBox(width: 8),
                FacilityCard(
                  imgPath: "assets/images/club amenities.png",
                  title: "Club Amenities",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class FacilityCard extends StatelessWidget {
  final String imgPath;
  final String title;

  const FacilityCard({super.key, required this.imgPath, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90, // keeps all cards equal in width
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFD6B686),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(imgPath, scale: 2),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 32, // fixed height for text (keeps cards aligned)
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Upcoming Events & Team Section

class UpcomingEventsSection extends StatelessWidget {
  const UpcomingEventsSection({super.key});

  Widget _buildEventCard(EventModel event, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${event.startDate ?? ""} - ${event.endDate ?? ""}"),
          const SizedBox(height: 4),
          Text(
            event.eventName ?? "",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: "View more",
              onPressed: () {
                NavigationService.instance.navigateToTab(2);
                // Navigator.of(context).pushNamed(
                //   RoutesName.eventDetailsScreen,
                //   arguments: {"refNo": event.refNo ?? ""},
                // );
              },
              borderRadius: 8,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Upcoming Events Title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "Upcoming Events",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B592A),
            ),
          ),
        ),
        const SizedBox(height: 10),

        BlocProvider.value(
          value: context.read<EventsBloc>(),
          child: BlocBuilder<EventsBloc, EventsState>(
            builder: (context, state) {
              if (state is EventsInitial) {
                context.read<EventsBloc>().add(FetchEvents(upcoming: true));
              }

              if (state is EventsLoading) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state is EventsLoaded) {
                final events = state.events ?? [];

                if (events.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                    child: Text("No upcoming events available."),
                  );
                }

                final List<EventModel> upcomingEvents = events.take(3).toList();

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: upcomingEvents
                        .map((event) => _buildEventCard(event, context))
                        .toList(),
                  ),
                );
              }

              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                child: Text("Failed to load events."),
              );
            },
          ),
        ),

        /// Team Title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "Board of Members",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B592A),
            ),
          ),
        ),
        const SizedBox(height: 10),

        /// Team Carousel
        SizedBox(
          height: 160,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: dummyTeam.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final member = dummyTeam[index];
              return Container(
                width: 100,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey,
                      backgroundImage: member["image"] != null
                          ? AssetImage(member["image"]!)
                          : null,
                      child: member["image"] == null
                          ? const Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      member["name"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Dummy Team Data
final List<Map<String, String>> dummyTeam = [
  {"name": "Romit Bose"},
  {"name": "Ananya Singh"},
  {"name": "Vikram Sharma"},
  {"name": "Sonal Mehra"},
  {"name": "Arjun Khanna"},
];

/// Custom Button (your style)
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double borderRadius;
  final EdgeInsets padding;
  final Color textColor; // Add this line

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    this.textColor = Colors.white, // Add this line with default value
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF12563C),
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          // Update to use textColor parameter
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Bottom Banner
class BottomBanner extends StatelessWidget {
  const BottomBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: AssetImage("assets/images/banner golf.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          /// Text Overlay (Eagle Mountain Golf Club)
          Positioned(
            left: 16,
            top: 20,
            child: Text(
              "Eagle Mountain\nGolf Club",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 4,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
          ),

          /// Book Tee Time Button (Bottom Right)
          // Positioned(
          //   right: 12,
          //   bottom: 12,
          //   child: CustomButton(
          //     text: "Book Tee Time",
          //     onPressed: () {
          //       NavigationService.instance.navigateToTab(3);
          //     },
          //     textColor: const Color.fromARGB(
          //       255,
          //       249,
          //       251,
          //       250,
          //     ), // ✅ green text
          //     borderRadius: 30, // ✅ rounded edges
          //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //   ),
          // ),
        ],
      ),
    );
  }
}
