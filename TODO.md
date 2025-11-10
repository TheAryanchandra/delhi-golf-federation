# TODO: Implement Named Routes for News Details Navigation

## Tasks
- [x] Add new route name `newsDetailsScreen` in `lib/config/routes_name.dart`
- [x] Update `lib/config/routes.dart` to handle the new route in `onGenerateRoute`, extracting `refNo` and passing to `NewsDetailsScreen`
- [x] Modify `lib/screens/news.dart` to use `Navigator.pushNamed` with new route and pass `{'refNo': item.refNo}`
- [x] Update `lib/screens/newsviewmore.dart` (`NewsDetailsScreen`) to accept `refNo` as required parameter
- [x] Test the navigation to ensure it works correctly
- [ ] (Optional) Implement fetching description using refNo if API endpoint exists
