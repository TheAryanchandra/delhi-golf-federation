# TODO: Add Navigation from Event Screen to Event Details Screen

## Steps to Complete:
- [x] Add route name for event details in `lib/config/routes_name.dart`
- [x] Update `lib/config/routes.dart` to include event details route in `onGenerateRoute`, accepting EventModel as argument
- [x] Modify `lib/screens/event_details_screen.dart` to accept EventModel and display dynamic event data instead of hardcoded values
- [x] Update the "View" button's `onPressed` in `lib/screens/event_screen.dart` to navigate to event details screen, passing the event data
