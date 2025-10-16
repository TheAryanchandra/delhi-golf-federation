import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  static NavigationService get instance => _instance;

  Function(String)? _navigateToBookingFlow;
  Function(int)? _navigateToTab;

  // ======== SETTERS ========

  void setBookingFlowNavigator(Function(String) navigator) {
    _navigateToBookingFlow = navigator;
  }

  void setTabNavigator(Function(int) navigator) {
    _navigateToTab = navigator;
  }

  // ======== NAVIGATION HELPERS ========

  void navigateToBookingFlow(String flow) {
    _navigateToBookingFlow?.call(flow);
  }

  void navigateToTab(int index) {
    _navigateToTab?.call(index);
  }

  // ✅ Added this new method for clean tab change (used from Profile screen)
  void changeTab(int index) {
    _navigateToTab?.call(index);
  }

  // ======== SHORTCUTS ========

  void navigateToBooking() => navigateToBookingFlow('booking');
  void navigateToSlotDetails() => navigateToBookingFlow('slot-details');
  void navigateToPayment() => navigateToBookingFlow('payment');
  void navigateToBookTeeTime() => navigateToBookingFlow('main');
  void navigateToHomepage() => navigateToTab(0);
}
