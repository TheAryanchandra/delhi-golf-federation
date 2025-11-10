import 'package:delhi_golf_federation/bloc/worldofgolf/bloc/worldofgolf_bloc.dart';
import 'package:delhi_golf_federation/bloc/worldofgolf/bloc/worldofgolf_event.dart';
import 'package:delhi_golf_federation/bloc/worldofgolf/bloc/worldofgolf_state.dart';
import 'package:delhi_golf_federation/components/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:delhi_golf_federation/model/worldofgolf_model.dart';
import 'package:delhi_golf_federation/data/worldofgolf_repository.dart';

class NewsDetailsScreen extends StatefulWidget {
  final String refNo;

  const NewsDetailsScreen({super.key, required this.refNo});

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  late WorldOfGolfBloc _bloc;
  WorldOfGolfItem? newsItem;

  @override
  void initState() {
    super.initState();

    print("📰 Opening NewsDetailsScreen...");
    print("📎 RefNo received: ${widget.refNo}");

    _bloc = WorldOfGolfBloc(WorldOfGolfRepository());

    // Dispatch event with RefNo
    _bloc.add(FetchWorldOfGolfEvent(
      action: "GetNewsSingleData",
      entryType: "News",
      id: "", // empty
      refNo: widget.refNo, // ✅ send refNo to repository
    ));

    print("🚀 FetchWorldOfGolfEvent dispatched for RefNo: ${widget.refNo}");
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorConstants.buttonColor,
        title: const Text(
          "News Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocProvider(
        create: (_) => _bloc,
        child: BlocBuilder<WorldOfGolfBloc, WorldOfGolfState>(
          builder: (context, state) {
            if (state is WorldOfGolfLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is WorldOfGolfError) {
              return Center(
                child: Text(
                  "❌ ${state.message}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state is WorldOfGolfLoaded) {
              // Try to find the matching news item by RefNo
              try {
                newsItem = state.items.firstWhere(
                  (item) => item.refNo == widget.refNo,
                );
              } catch (e) {
                print("⚠️ No matching news item found for RefNo: ${widget.refNo}");
                newsItem = null;
              }

              if (newsItem == null) {
                return const Center(child: Text("No data found"));
              }

              print("✅ News item found: ${newsItem!.eventName}");

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🖼️ Image
                    if (newsItem!.image != null &&
                        newsItem!.image!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          "https://delhigolf.org${newsItem!.image}",
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            height: 220,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.broken_image_outlined,
                              size: 50,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // 🗓️ Date
                    Text(
                      newsItem!.startDate?.isNotEmpty == true
                          ? newsItem!.startDate!
                          : "No date available",
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),

                    const SizedBox(height: 8),

                    // 📰 Title
                    Text(
                      newsItem!.eventType ?? "No title available",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // 📰 Subtitle
                    if (newsItem!.eventName != null &&
                        newsItem!.eventName!.isNotEmpty)
                      Text(
                        newsItem!.eventName!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),

                    const SizedBox(height: 16),

                    // 📜 Description (HTML)
                    if (newsItem!.content != null &&
                        newsItem!.content!.isNotEmpty)
                      Html(
                        data: newsItem!.content,
                        style: {
                          "p": Style(
                            fontSize: FontSize(15),
                            color: Colors.black87,
                            lineHeight: const LineHeight(1.5),
                          ),
                        },
                      )
                    else
                      const Text(
                        "No description available.",
                        style: TextStyle(fontSize: 15, color: Colors.black87),
                      ),

                    const SizedBox(height: 30),

                    // 🔘 Back Button
                    // Center(
                    //   child: ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: ColorConstants.buttonColor,
                    //       padding: const EdgeInsets.symmetric(
                    //         horizontal: 36,
                    //         vertical: 12,
                    //       ),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(12),
                    //       ),
                    //     ),
                    //     onPressed: () => Navigator.pop(context),
                    //     child: const Text(
                    //       "Back",
                    //       style: TextStyle(
                    //         fontSize: 16,
                    //         color: Colors.white,
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              );
            }

            return const Center(child: Text("No data found"));
          },
        ),
      ),
    );
  }
}
