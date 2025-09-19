import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  static NavigationService get instance => _instance;

  Function(String)? _navigateToBookingFlow;
  Function(int)? _navigateToTab;

  void setBookingFlowNavigator(Function(String) navigator) {
    _navigateToBookingFlow = navigator;
  }

  void setTabNavigator(Function(int) navigator) {
    _navigateToTab = navigator;
  }

  void navigateToBookingFlow(String flow) {
    _navigateToBookingFlow?.call(flow);
  }

  void navigateToTab(int index) {
    _navigateToTab?.call(index);
  }

  void navigateToBooking() => navigateToBookingFlow('booking');
  void navigateToSlotDetails() => navigateToBookingFlow('slot-details');
  void navigateToPayment() => navigateToBookingFlow('payment');
  void navigateToBookTeeTime() => navigateToBookingFlow('main');
  void navigateToHomepage() => navigateToTab(0);
}