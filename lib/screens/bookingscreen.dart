import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int selectedDateIndex = 3; // Example: Mon 01 is selected
  int selectedTee = 1; // Tee 1 selected

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
    {"time": "5:50 AM", "status": "Booked"},
    {"time": "5:50 AM", "status": "Available"},
    {"time": "5:50 AM", "status": "Booked"},
    {"time": "5:50 AM", "status": "Booked"},
    {"time": "5:50 AM", "status": "Booked"},
    {"time": "5:50 AM", "status": "Booked"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF2F1),
      body: Padding(
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
          height: 60,
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
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (date['highlight'] ?? Colors.green)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        date['day'],
                        style: TextStyle(
                          color: date['highlight'] ?? Colors.black,
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
        const SizedBox(width: 8),
        _buildTeeButton("Tee 10", 10),
      ],
    );
  }

  Widget _buildTeeButton(String label, int tee) {
    final bool isSelected = selectedTee == tee;
    return GestureDetector(
      onTap: () => setState(() => selectedTee = tee),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSlotList() {
    return ListView.separated(
      itemCount: slots.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final slot = slots[index];
        final bool isAvailable = slot['status'] == "Available";

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF12563C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 18),
                      ),
                      onPressed: () {
                        // Navigate to slot details screen
                      },
                      child: const Text("Book"),
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
