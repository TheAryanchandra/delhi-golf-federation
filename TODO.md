# TODO: Fix Leaderboard Update Issue After Score Submission

## Steps to Complete:
- [ ] Remove BlocProvider from LeaderboardScreen to use global LeaderboardScreenBloc
- [ ] Add trigger to fetch leaderboard data in EventScorecard after successful submission
- [ ] Test the navigation and update behavior

## Information Gathered:
- LeaderboardScreen currently creates its own LeaderboardScreenBloc instance via BlocProvider, overriding the global one.
- EventScorecard submits scores using LeaderboardBloc, then navigates to CustomBottomNav(initialIndex: 1) for leaderboard.
- Global LeaderboardScreenBloc is provided in main.dart, but not used in LeaderboardScreen due to local BlocProvider.

## Plan:
- Modify LeaderboardScreen to remove local BlocProvider and use the global LeaderboardScreenBloc.
- In EventScorecard, after successful score submission, trigger a fetch on the global LeaderboardScreenBloc to update the leaderboard data.
- Ensure navigation to leaderboard tab works correctly.

## Dependent Files:
- lib/screens/leaderboard_screen.dart
- lib/screens/eventscorecard.dart

## Followup Steps:
- Test the app to verify leaderboard updates after score submission.
- Check for any errors in bloc state management.
