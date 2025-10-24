import 'package:delhi_golf_federation/widgets/commonwebpage.dart';
import 'package:flutter/material.dart';

class IGURankingScreen extends StatelessWidget {
  const IGURankingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CommonWebPageScreen(
      title: "IGU Ranking",
      url: "https://indiangolfunion.org/order-of-merit-2025/",
    );
  }
}
