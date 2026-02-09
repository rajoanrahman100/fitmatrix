# FitMatrix

FitMatrix is a Flutter workout companion built around a 7‑week push/pull/legs routine. It tracks weekly progress, highlights the current day, and lets you mark sessions complete with persistent local storage.

## Features
- 7‑week program with a Saturday → Thursday training split
- Week selector with per‑week progress tracking
- Calendar strip to select the active day (tap) and toggle completion (long‑press)
- Streak tracking (current and best)
- Workout detail view with exercise breakdown
- “Mark All Done” for a full session
- Local persistence with `shared_preferences`

## Tech Stack
- Flutter (Material 3)
- State management: `flutter_bloc` (Cubit)
- Local storage: `shared_preferences`
- Typography: `google_fonts`

## Project Structure
```
lib/
  app/
    fitmatrix_app.dart
  data/
    workout_data.dart
  features/
    detail/
      workout_detail_screen.dart
    home/
      home_screen.dart
      widgets/
        background_glow.dart
        header_section.dart
        routine_card.dart
        routine_list.dart
        week_calendar.dart
        week_selector.dart
        weekly_split.dart
    progress/
      progress_cubit.dart
      progress_panel.dart
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

## Customization
You can edit the routine in:
- `lib/data/workout_data.dart`

You can tweak the theme in:
- `lib/theme/app_theme.dart`

## Roadmap Ideas
- Editable routine and custom sets
- Timers per exercise
- Cloud sync across devices

## License
This project is for personal use. Add a license if you plan to distribute publicly.

