import '../models/workout_models.dart';

/// Centralized routine data and helpers for week/day ordering.
class WorkoutData {
  static const List<String> weekdayLabels = [
    'Sat',
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
  ];

  /// Maps Dart weekday constants to the app's Saturday-first index.
  static int? indexForWeekday(int weekday) {
    switch (weekday) {
      case DateTime.saturday:
        return 0;
      case DateTime.sunday:
        return 1;
      case DateTime.monday:
        return 2;
      case DateTime.tuesday:
        return 3;
      case DateTime.wednesday:
        return 4;
      case DateTime.thursday:
        return 5;
      default:
        return null;
    }
  }

  /// Builds the 7-week program by repeating the base week.
  static List<WorkoutWeek> buildWeeks() {
    final baseDays = _buildBaseWeek();
    return List<WorkoutWeek>.generate(
      7,
      (index) => WorkoutWeek(label: 'Week ${index + 1}', days: baseDays),
    );
  }

  /// Defines the Saturday–Thursday workout plan used for each week.
  static List<WorkoutDay> _buildBaseWeek() {
    return [
      WorkoutDay(
        title: 'Saturday — Push (Strength & Hypertrophy)',
        subtitle: 'Chest, shoulders, triceps',
        sections: [
          WorkoutSection(
            title: 'Warm-up',
            exercises: const [
              Exercise(name: 'Cardio', detail: '5-10 min'),
              Exercise(name: 'Dynamic stretches', detail: 'Upper body focus'),
            ],
          ),
          WorkoutSection(
            title: 'Main Lifts',
            exercises: const [
              Exercise(name: 'Barbell Bench Press', detail: '4 x 6-8'),
              Exercise(name: 'Incline Dumbbell Press', detail: '4 x 8-10'),
              Exercise(name: 'Standing Overhead Press', detail: '4 x 6-8'),
            ],
          ),
          WorkoutSection(
            title: 'Accessory & Finishers',
            exercises: const [
              Exercise(name: 'Cable Flyes (Mid/Low)', detail: '3 x 12-15'),
              Exercise(name: 'Lateral Raises', detail: '4 x 12-15 (superset)'),
              Exercise(name: 'Front Raises', detail: '4 x 12-15'),
              Exercise(name: 'Overhead Tricep Extension', detail: '3 x 10-12'),
              Exercise(name: 'Tricep Pushdowns', detail: '3 x 12-15'),
            ],
          ),
        ],
      ),
      WorkoutDay(
        title: 'Sunday — Pull (Width & Thickness)',
        subtitle: 'Back, biceps, rear delts',
        sections: [
          WorkoutSection(
            title: 'Heavy Pulls',
            exercises: const [
              Exercise(name: 'Deadlifts', detail: '4 x 5-6 heavy'),
              Exercise(name: 'Weighted Pull-ups / Chin-ups', detail: '4 x 6-10'),
              Exercise(name: 'Barbell Rows', detail: '4 x 8-10'),
            ],
          ),
          WorkoutSection(
            title: 'Back Volume',
            exercises: const [
              Exercise(name: 'Lat Pulldowns (Wide Grip)', detail: '3 x 10-12'),
              Exercise(name: 'Cable Rows (Neutral Grip)', detail: '3 x 12-15'),
              Exercise(name: 'Face Pulls', detail: '4 x 15-20'),
            ],
          ),
          WorkoutSection(
            title: 'Biceps',
            exercises: const [
              Exercise(name: 'Barbell Curls', detail: '3 x 8-10'),
              Exercise(name: 'Hammer Curls', detail: '3 x 10-12'),
              Exercise(name: 'Cable Curls', detail: '2 x 15-20'),
            ],
          ),
        ],
      ),
      WorkoutDay(
        title: 'Monday — Legs (Complete Development)',
        subtitle: 'Quads, hamstrings, glutes, calves',
        sections: [
          WorkoutSection(
            title: 'Main Lifts',
            exercises: const [
              Exercise(name: 'Back Squats', detail: '4 x 6-8'),
              Exercise(name: 'Romanian Deadlifts', detail: '4 x 8-10'),
              Exercise(name: 'Bulgarian Split Squats', detail: '3 x 10-12 each'),
            ],
          ),
          WorkoutSection(
            title: 'Volume & Finishers',
            exercises: const [
              Exercise(name: 'Leg Press', detail: '3 x 12-15'),
              Exercise(name: 'Leg Curls', detail: '4 x 10-12'),
              Exercise(name: 'Walking Lunges', detail: '3 x 12 steps each'),
            ],
          ),
          WorkoutSection(
            title: 'Calves',
            exercises: const [
              Exercise(name: 'Standing Calf Raises', detail: '4 x 12-15'),
              Exercise(name: 'Seated Calf Raises', detail: '3 x 15-20'),
            ],
          ),
        ],
      ),
      WorkoutDay(
        title: 'Tuesday — Push (Volume & Muscle Damage)',
        subtitle: 'Chest, shoulders, triceps',
        sections: [
          WorkoutSection(
            title: 'Pressing Focus',
            exercises: const [
              Exercise(name: 'Incline Barbell Press', detail: '4 x 8-10'),
              Exercise(name: 'Flat Dumbbell Press', detail: '4 x 10-12'),
              Exercise(name: 'Dumbbell Shoulder Press', detail: '4 x 10-12'),
            ],
          ),
          WorkoutSection(
            title: 'Volume & Pump',
            exercises: const [
              Exercise(name: 'Cable Crossovers (High to Low)', detail: '3 x 12-15'),
              Exercise(name: 'Arnold Press', detail: '3 x 10-12'),
              Exercise(name: 'Lateral Raises (Drop Sets)', detail: '3 x 12-15 + drops'),
            ],
          ),
          WorkoutSection(
            title: 'Triceps',
            exercises: const [
              Exercise(name: 'Close-Grip Bench Press', detail: '3 x 8-10'),
              Exercise(name: 'Dips', detail: '3 x 10-12 (weighted if possible)'),
              Exercise(name: 'Rope Pushdowns', detail: '3 x 15-20'),
            ],
          ),
        ],
      ),
      WorkoutDay(
        title: 'Wednesday — Pull (Power & Symmetry Focus)',
        subtitle: 'Back, biceps, rear delts',
        sections: [
          WorkoutSection(
            title: 'Strength Rows',
            exercises: const [
              Exercise(name: 'Weighted Pull-ups (Wide Grip)', detail: '5 x 5-8'),
              Exercise(name: 'T-Bar Rows', detail: '4 x 8-10'),
              Exercise(name: 'Single-Arm Dumbbell Rows', detail: '4 x 10-12 each'),
            ],
          ),
          WorkoutSection(
            title: 'Back Detail',
            exercises: const [
              Exercise(name: 'Straight-Arm Pulldowns', detail: '3 x 12-15'),
              Exercise(name: 'Chest-Supported Rows', detail: '3 x 10-12'),
              Exercise(name: 'Reverse Pec Deck', detail: '4 x 15-20'),
            ],
          ),
          WorkoutSection(
            title: 'Biceps',
            exercises: const [
              Exercise(name: 'Incline Dumbbell Curls', detail: '4 x 10-12'),
              Exercise(name: 'Preacher Curls', detail: '3 x 10-12'),
              Exercise(name: 'Concentration Curls', detail: '2 x 12-15 each'),
            ],
          ),
        ],
      ),
      WorkoutDay(
        title: 'Thursday — Rest / Active Recovery',
        subtitle: 'Restore, mobilize, and get ready for next week',
        sections: [
          WorkoutSection(
            title: 'Active Recovery Ideas',
            exercises: const [
              Exercise(name: 'Light cardio', detail: '20-30 min walk or cycle'),
              Exercise(name: 'Mobility flow', detail: '10-15 min full body'),
              Exercise(name: 'Stretching', detail: 'Focus on hips and shoulders'),
            ],
          ),
        ],
      ),
    ];
  }
}
