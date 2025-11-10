import 'package:delhi_golf_federation/bloc/worldofgolf/bloc/worldofgolf_bloc.dart';
import 'package:delhi_golf_federation/bloc/worldofgolf/bloc/worldofgolf_event.dart';
import 'package:delhi_golf_federation/bloc/worldofgolf/bloc/worldofgolf_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:delhi_golf_federation/components/topnavigationbar.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  int currentPage = 1;
  final int itemsPerPage = 20;

  @override
  void initState() {
    super.initState();
    // Fetch gallery images from API when screen loads
    context.read<WorldOfGolfBloc>().add(
      FetchWorldOfGolfEvent(
        action: "GallaryReport",
        entryType: "Gallery",
        page: currentPage,
      ),
    );
  }

  void _changePage(int page) {
    setState(() {
      currentPage = page;
    });
    context.read<WorldOfGolfBloc>().add(
      FetchWorldOfGolfEvent(
        action: "GallaryReport",
        entryType: "Gallery",
        page: page,
      ),
    );
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
                  height: screenHeight * 0.125,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: screenHeight * 0.125,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.4),
                ),
                const Text(
                  "Gallery",
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

          const SizedBox(height: 12),

          // BLoC Builder to handle API states
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: BlocBuilder<WorldOfGolfBloc, WorldOfGolfState>(
                builder: (context, state) {
                  if (state is WorldOfGolfLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WorldOfGolfLoaded) {
                    if (state.items.isEmpty) {
                      return const Center(
                        child: Text(
                          "No images found",
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 1.2,
                                ),
                            itemCount: state.items.length,
                            itemBuilder: (context, index) {
                              final image = state.items[index];
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  "https://delhigolf.org${image.venue}",
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.broken_image_outlined,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
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
                              ...List.generate(state.totalPage, (index) {
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
                                onPressed: currentPage < state.totalPage
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

                  // Initial / Default
                  return const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
