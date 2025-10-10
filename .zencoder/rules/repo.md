# Repository Guidance

- **Project Type**: Flutter mobile application for the Delhi Golf Federation.
- **Primary Focus Areas**:
  - Networking layer built with Dio.
  - Authentication flows (login, refresh, logout) and related repositories.
  - Integration with SharedPreferences for persistent auth state.
- **Common Tasks**:
  1. Debugging and enhancing API clients (Dio interceptors, token refresh).
  2. Aligning repositories to use shared networking utilities.
  3. Maintaining robust error handling and logging.
- **Preferred Practices**:
  - Use `Dio` for all HTTP requests; avoid mixing raw `http` unless necessary.
  - Centralize configuration in `lib/config`, especially `network` constants and clients.
  - Keep authentication state consistent across SharedPreferences and BLoC.
  - Add logs via existing logging utilities before introducing new ones.
- **Testing & Validation**:
  - Run `flutter analyze` before commits.
  - Prefer widget tests for UI changes; integration tests for auth flows when possible.
- **Communication Notes**:
  - Explain rationale for auth-related changes clearly.
  - Highlight any required manual setup (API keys, environment variables).