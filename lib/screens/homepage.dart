import 'package:delhi_golf_federation/bloc/banner/banner_bloc.dart';
import 'package:delhi_golf_federation/bloc/banner/banner_event.dart';
import 'package:delhi_golf_federation/bloc/banner/banner_state.dart';
import 'package:delhi_golf_federation/components/topnavigationbar.dart';
import 'package:delhi_golf_federation/components/customdrawer.dart';
import 'package:delhi_golf_federation/widgets/homepagewidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// <-- import your reusable TopNavigationBar

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: const [
            /// Banner
            _TopBanner(),

            SizedBox(height: 15),

            /// Sponsors Section
            SponsorsSection(),

            SizedBox(height: 20),

            /// Golf Club Facilities
            GolfClubFacilities(),

            SizedBox(height: 20),

            /// Upcoming Events + Team Section
            UpcomingEventsSection(),

            SizedBox(height: 20),

            /// Bottom Banner
            BottomBanner(),
          ],
        ),
      ),
    );
  }
}

class _TopBanner extends StatefulWidget {
  const _TopBanner();

  @override
  State<_TopBanner> createState() => _TopBannerState();
}

class _TopBannerState extends State<_TopBanner> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<BannerBloc>().add(FetchBanners());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerBloc, BannerState>(
      builder: (context, state) {
        if (state is BannerLoading) {
          return _shimmerBanner();
        }

        if (state is BannerLoaded) {
          if (state.banners.isEmpty) {
            return const SizedBox();
          }

          return Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  height: 140,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: state.banners.length,
                    onPageChanged: (index) {
                      setState(() => _currentIndex = index);
                    },
                    itemBuilder: (context, index) {
                      final banner = state.banners[index];

                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background Image
                          Image.network(
                            banner.bannerImage.isNotEmpty
                                ? "https://delhigolf.org${banner.bannerImage}"
                                : "",
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                "assets/images/welcome.png",
                                height: 140,
                                width: double.infinity,
                                fit: BoxFit.contain,
                              );
                            },
                          ),

                          // Dark overlay
                          Container(
                            height: 140,
                            width: double.infinity,
                            color: Colors.black.withOpacity(0.45),
                          ),

                          // Text overlay
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  banner.bannerTitle,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  banner.bannerTitle2,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFFD6B686),
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (banner.bannerTitle3.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    banner.bannerTitle3,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Dots Indicator
              _DotsIndicator(
                count: state.banners.length,
                currentIndex: _currentIndex,
              ),
            ],
          );
        }

        if (state is BannerError) {
          return const SizedBox(); // fail silently for home banner
        }

        return const SizedBox();
      },
    );
  }

  Widget _shimmerBanner() {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _DotsIndicator({required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: currentIndex == index ? 18 : 8,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? const Color(0xFFD6B686)
                : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
