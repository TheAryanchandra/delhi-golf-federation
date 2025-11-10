import 'package:delhi_golf_federation/screens/golfrankingwidget.dart';
import 'package:flutter/material.dart';
import 'package:delhi_golf_federation/components/topnavigationbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:delhi_golf_federation/bloc/golfranking/bloc/golf_ranking_bloc.dart';
import 'package:delhi_golf_federation/bloc/golfranking/bloc/golf_ranking_event.dart';
import 'package:delhi_golf_federation/model/golf_ranking_model.dart';
import 'package:delhi_golf_federation/bloc/auth/auth_bloc.dart';
import 'package:delhi_golf_federation/bloc/auth/auth_event.dart';
import 'package:delhi_golf_federation/bloc/auth/auth_state.dart';
import 'package:delhi_golf_federation/bloc/event_search/bloc/event_search_bloc.dart';
import 'package:delhi_golf_federation/bloc/event_search/bloc/event_search_event.dart';
import 'package:delhi_golf_federation/data/event_search_repository.dart';
import 'package:delhi_golf_federation/data/auth_repository.dart';

class DelhiGolfRankingScreen extends StatefulWidget {
  const DelhiGolfRankingScreen({Key? key}) : super(key: key);

  @override
  State<DelhiGolfRankingScreen> createState() => _DelhiGolfRankingScreenState();
}

class _DelhiGolfRankingScreenState extends State<DelhiGolfRankingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _amateurSubTabController;

  String _selectedGender = "Boys";
  String _selectedCategory = "Category A";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _amateurSubTabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return MultiBlocProvider(
      providers: [
        BlocProvider<IndustryBloc>(
          create: (context) => IndustryBloc(IndustryRepository())..add(FetchIndustriesEvent()),
        ),
        BlocProvider<EventSearchBloc>(
          create: (context) => EventSearchBloc(EventSearchRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: TopNavigationBar(
            showBackButton: true,
            onBackTap: () => Navigator.pop(context),
          ),
          body: Column(
            children: [
              // 🔹 HEADER
              RankingHeader(screenHeight: screenHeight),

              const SizedBox(height: 16),

              // 🔹 Main Tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: RankingTabBar(
                  tabController: _tabController,
                  onTabSelected: (index) {
                    setState(() {
                      _tabController.index = index;
                    });
                    // Trigger API call for Pro Elite when selected
                    if (index == 0) {
                      context.read<GolfRankingBloc>().add(
                        FetchGolfRankingEvent(
                          GolfRankingRequest(
                            action: "ProEliteData",
                            pageSize: 10,
                            page: 1,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),

              const SizedBox(height: 10),

              // 🔹 TAB CONTENT
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // 🟢 Pro Elite
                    const RankingTable(action: "ProEliteData"),

                    // 🟢 Amateur Elite
                    AmateurEliteSection(
                      tabController: _amateurSubTabController,
                    ),

                    // 🟢 Junior Elite
                    JuniorEliteSection(
                      selectedGender: _selectedGender,
                      selectedCategory: _selectedCategory,
                    ),

                    // 🟢 Club Golfers
                    const ClubGolfersTable(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
