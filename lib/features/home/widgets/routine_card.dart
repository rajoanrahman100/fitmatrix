import 'package:flutter/material.dart';

import '../../../models/workout_models.dart';
import '../../detail/workout_detail_screen.dart';

/// Tappable card that shows a single workout day summary.
class RoutineCard extends StatelessWidget {
  const RoutineCard({
    super.key,
    required this.day,
    required this.dayIndex,
    required this.isCompleted,
    required this.onToggle,
    this.showEstimate = false,
  });

  final WorkoutDay day;
  final int dayIndex;
  final bool isCompleted;
  final VoidCallback onToggle;
  final bool showEstimate;

  /// Builds the card UI and handles navigation to details.
  @override
  Widget build(BuildContext context) {
    final estimatedMinutes = _estimateMinutes(day);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => WorkoutDetailScreen(
              day: day,
              dayIndex: dayIndex,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: onToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isCompleted
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.white38,
                      width: 1.4,
                    ),
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, size: 18, color: Colors.black)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      day.subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${day.sections.length} sections',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white54,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }

  int _estimateMinutes(WorkoutDay day) {
    var minutes = 0.0;
    var totalSets = 0;
    final setPattern = RegExp(r'(\\d+)\\s*[x×]');
    final minPattern = RegExp(r'(\\d+)\\s*-\\s*(\\d+)\\s*min|(\\d+)\\s*min');

    for (final section in day.sections) {
      for (final exercise in section.exercises) {
        final detail = exercise.detail.toLowerCase();
        final minMatch = minPattern.firstMatch(detail);
        if (minMatch != null) {
          final start = minMatch.group(1);
          final end = minMatch.group(2);
          final single = minMatch.group(3);
          if (start != null && end != null) {
            minutes += (int.parse(start) + int.parse(end)) / 2;
          } else if (single != null) {
            minutes += int.parse(single).toDouble();
          }
          continue;
        }

        final setMatch = setPattern.firstMatch(detail);
        if (setMatch != null) {
          final sets = int.tryParse(setMatch.group(1) ?? '') ?? 0;
          totalSets += sets;
          minutes += sets * 2.5; // average work + rest time per set
        }
      }
    }

    if (minutes == 0.0 && totalSets > 0) {
      minutes = totalSets * 2.5;
    }

    if (minutes == 0.0) {
      minutes = 8.0;
    }

    return minutes.round().clamp(5, 240);
  }
}
