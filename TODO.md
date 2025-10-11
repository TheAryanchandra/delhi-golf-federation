# TODO: Handle "Time out re-login" message and navigate to login screen

## Tasks
- [x] Modify `RefreshTokenRepository.refreshToken()` in `lib/data/auth_repository.dart` to parse response data even on DioException (e.g., 408 status), allowing the message to be checked.
- [x] Update `main.dart` to assign `navigatorKey` to the `MaterialApp` for proper navigation handling.
