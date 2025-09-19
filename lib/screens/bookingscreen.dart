import 'package:delhi_golf_federation/components/custombutton.dart';
import 'package:delhi_golf_federation/services/navigation_service.dart';
import 'package:flutter/material.dart';
import '../components/color_constants.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int selectedDateIndex = 3; // Default selected date
  int selectedTee = 1; // Default Tee

  final List<Map<String, dynamic>> dates = [
    {"day": "Fri", "date": "29"},
    {"day": "Sat", "date": "30", "highlight": Colors.red},
    {"day": "Sun", "date": "31", "highlight": Colors.red},
    {"day": "Mon", "date": "01", "highlight": Colors.green},
    {"day": "Tue", "date": "02"},
    {"day": "Wed", "date": "03"},
    {"day": "Thu", "date": "04"},
  ];

  final List<Map<String, dynamic>> slots = [
    {"time": "5:50 AM", "status": "Booked"},
    {"time": "6:10 AM", "status": "Available"},
    {"time": "6:30 AM", "status": "Booked"},
    {"time": "6:50 AM", "status": "Available"},
    {"time": "7:10 AM", "status": "Booked"},
    {"time": "7:30 AM", "status": "Available"},
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: const Color(0xFFEFF2F1),
      child: Column(
        children: [
          // ✅ Header with background image + overlay + title + subtitle
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Book Tee Time",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Qutab Golf Course - DDA",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ✅ Rest of the booking UI
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildDateSelector(),
                  const SizedBox(height: 12),
                  _buildTeeSelector(),
                  const SizedBox(height: 8),
                  const Text(
                    "Sheet Open Till 17 Hours Before Tee Off",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Expanded(child: _buildSlotList()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      children: [
        const Text(
          "August / September 2025",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 65,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              final bool isSelected = index == selectedDateIndex;
              return GestureDetector(
                onTap: () => setState(() => selectedDateIndex = index),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (date['highlight'] ?? ColorConstants.buttonColor)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: date['highlight'] ?? ColorConstants.buttonColor,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        date['day'],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date['date'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTeeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTeeButton("Tee 1", 1),
        const SizedBox(width: 10),
        _buildTeeButton("Tee 10", 10),
      ],
    );
  }

  Widget _buildTeeButton(String label, int tee) {
    final bool isSelected = selectedTee == tee;
    return GestureDetector(
      onTap: () => setState(() => selectedTee = tee),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? ColorConstants.buttonColor : Colors.white,
          border: Border.all(color: ColorConstants.buttonColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : ColorConstants.buttonColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSlotList() {
    return ListView.separated(
      itemCount: slots.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final slot = slots[index];
        final bool isAvailable = slot['status'] == "Available";

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(slot['time'],
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text("Pay & Play",
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              isAvailable
                  ? CustomButton(
                      text: "Book",
                      onPressed: () {
                        NavigationService.instance.navigateToSlotDetails();
                      },
                      textColor: Colors.white,
                      borderRadius: 12,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                    )
                  : const Text(
                      "Booked",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
            ],
          ),
        );
      },
    );
  }
}
