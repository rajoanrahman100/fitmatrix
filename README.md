# FitMatrix

FitMatrix is a Flutter workout companion built around a 7‑week push/pull/legs routine (Saturday → Thursday). It tracks weekly progress, highlights the current day, and lets you mark sessions complete with persistent local storage.

## Features
- 7‑week program with a Saturday → Thursday training split
- Home shows the selected day workout (clean UX)
- Week selector with per‑week progress tracking
- Calendar strip to select the active day (tap) and toggle completion (long‑press)
- Separate Calendar screen synced to the 7‑week program
- Program start date picker in the Calendar screen
- Streak tracking (current and best)
- Workout detail view with exercise breakdown
- “Mark All Done” with confetti success feedback
- Progress stats screen with weekly bars + daily trend line
- Estimated time shown on All Workouts list cards
- Local persistence with `shared_preferences`

## Tech Stack
- Flutter (Material 3)
- State management: `flutter_bloc` (Cubit)
- Local storage: `shared_preferences`
- Typography: `google_fonts`
- Charts: `fl_chart`
- Splash: `flutter_native_splash`
- App icon: `flutter_launcher_icons`
- Confetti: `confetti`

## Project Structure
```
lib/
  app/
    fitmatrix_app.dart
  data/
    workout_data.dart
  features/
    calendar/
      calendar_screen.dart
    detail/
      workout_detail_screen.dart
    home/
      all_workouts_screen.dart
      home_screen.dart
      widgets/
        background_glow.dart
        header_section.dart
        routine_card.dart
        routine_list.dart
        selected_workout.dart
        week_calendar.dart
        week_selector.dart
        weekly_split.dart
    progress/
      progress_cubit.dart
      progress_panel.dart
    splash/
      splash_screen.dart
    stats/
      stats_screen.dart
  models/
    workout_models.dart
  theme/
    app_theme.dart
  main.dart
```

## Getting Started
### Prerequisites
- Flutter SDK installed
- Xcode or Android Studio set up for iOS/Android builds

### Install & Run
```bash
cd fitmatrix
flutter pub get
flutter run
```

## Usage Tips
- Tap a day in the Week Calendar to change the active day.
- Long‑press a day in the calendar to toggle completion.
- Tap a workout card to open the detailed routine view.
- Use “Reset This Week” to clear weekly completion.
- Open the Calendar screen to view the program on a month grid.
- Use “Set” in Calendar to choose the program start date.

## Customization
You can edit the routine in:
- `lib/data/workout_data.dart`

You can tweak the theme in:
- `lib/theme/app_theme.dart`

## Roadmap Ideas
- Editable routine and custom sets
- Timers per exercise
- Cloud sync across devices

