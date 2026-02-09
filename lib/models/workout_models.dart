/// Single exercise with its prescription details.
class Exercise {
  const Exercise({required this.name, required this.detail});

  final String name;
  final String detail;
}

/// A group of exercises within a workout day.
class WorkoutSection {
  const WorkoutSection({required this.title, required this.exercises});

  final String title;
  final List<Exercise> exercises;
}

/// A full day in the routine (e.g., Push, Pull, Legs).
class WorkoutDay {
  const WorkoutDay({
    required this.title,
    required this.subtitle,
    required this.sections,
  });

  final String title;
  final String subtitle;
  final List<WorkoutSection> sections;
}

/// A week container holding the ordered workout days.
class WorkoutWeek {
  const WorkoutWeek({required this.label, required this.days});

  final String label;
  final List<WorkoutDay> days;
}
