import 'dart:math';

import 'package:delhi_golf_federation/bloc/worldofgolf/bloc/worldofgolf_bloc.dart';
import 'package:delhi_golf_federation/bloc/worldofgolf/bloc/worldofgolf_event.dart';
import 'package:delhi_golf_federation/bloc/worldofgolf/bloc/worldofgolf_state.dart';
import 'package:delhi_golf_federation/components/custombutton.dart';
import 'package:delhi_golf_federation/components/topnavigationbar.dart';
import 'package:delhi_golf_federation/config/routes_name.dart';
import 'package:delhi_golf_federation/screens/newsviewmore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  int selectedTab = 0; // 0 = Latest News, 1 = Past News
  int currentPage = 1;
  final int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _fetchNews(); // 🔹 Fetch default tab (Latest News)
  }

  void _fetchNews() {
    final isLatest = selectedTab == 0;

    setState(() {
      currentPage = 1;
    });

    context.read<WorldOfGolfBloc>().add(
      FetchWorldOfGolfEvent(
        action: "GetNewsData",
        entryType: "News",
        id: isLatest ? " Latest" : "Past", // API expects this
      ),
    );
  }

  void _changePage(int page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFEFF2F1),
      body: Column(
        children: [
          // Header Section
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
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.4),
                ),
                const Text(
                  "News",
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

          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildTabs(),
          ),

          const SizedBox(height: 16),

          // News List (via Bloc)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BlocBuilder<WorldOfGolfBloc, WorldOfGolfState>(
                builder: (context, state) {
                  if (state is WorldOfGolfLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WorldOfGolfLoaded) {
                    if (state.items.isEmpty) {
                      return const Center(
                        child: Text(
                          "No news available",
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }

                    final totalPages = (state.items.length / itemsPerPage)
                        .ceil();
                    final startIndex = (currentPage - 1) * itemsPerPage;
                    final endIndex = min(
                      startIndex + itemsPerPage,
                      state.items.length,
                    );
                    final paginatedItems = state.items.sublist(
                      startIndex,
                      endIndex,
                    );

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            itemCount: paginatedItems.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final item = paginatedItems[index];

                              // 🧩 Fix the image URL — handle double/triple slashes properly
                              final imageUrl =
                                  (item.image != null && item.image!.isNotEmpty)
                                  ? "https://delhigolf.org${item.image}"
                                        .replaceAll(
                                          RegExp(r'\/{2,}'),
                                          '/',
                                        ) // removes // or ///
                                        .replaceFirst(
                                          'https:/',
                                          'https://',
                                        ) // fix protocol
                                  : null;

                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 🖼️ Image on Top
                                    if (imageUrl != null)
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                        child: Image.network(
                                          imageUrl,
                                          height: 180,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  height: 180,
                                                  width: double.infinity,
                                                  color: Colors.grey[300],
                                                  child: const Icon(
                                                    Icons.broken_image_outlined,
                                                    size: 40,
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              },
                                        ),
                                      ),

                                    // 📰 Text Content Below
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.startDate ?? "",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            (item.eventName?.isNotEmpty ??
                                                    false)
                                                ? item.eventName!
                                                : "Untitled News",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: CustomButton(
                                              text: "View more",
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  RoutesName.newsDetailsScreen,
                                                  arguments: {
                                                    'id': item.id ?? '',
                                                    'refNo': item.refNo ?? '',
                                                    'title':
                                                        item.eventName ??
                                                        "Untitled News",
                                                    'date':
                                                        item.startDate ?? "",
                                                    'imageUrl': imageUrl,
                                                    // description can be added later if available
                                                  },
                                                );
                                              },
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 8,
                                                  ),
                                              borderRadius: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  size: 16,
                                ),
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
                  } else if (state is WorldOfGolfError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          _buildTabButton("Latest News", 0),
          _buildTabButton("Past News", 1),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final bool isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => selectedTab = index);
          _fetchNews(); // 🔹 Refetch based on tab
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF12563C) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
