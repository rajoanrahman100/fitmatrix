import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'progress_cubit.dart';

/// Panel showing progress, streaks, and reset action.
class ProgressPanel extends StatelessWidget {
  const ProgressPanel({super.key});

  /// Builds the progress UI for the selected week.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressCubit, ProgressState>(
      builder: (context, state) {
        final selectedWeek = state.weeks[state.selectedWeek];
        final completedDays = state.completedByWeek[state.selectedWeek].length;
        final totalDays = selectedWeek.days.length;
        final weekProgress = totalDays == 0 ? 0.0 : completedDays / totalDays;
        final completedWeeks = state.completedWeekCount;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progress Tracker',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Week ${state.selectedWeek + 1}: ${completedDays}/${totalDays} sessions completed',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  minHeight: 10,
                  value: weekProgress,
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.auto_graph, color: Colors.white70, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Weeks completed: $completedWeeks / ${state.weeks.length}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 6,
                children: [
                  StreakChip(
                    label: 'Current streak',
                    value: '${state.currentStreak} days',
                  ),
                  StreakChip(
                    label: 'Best streak',
                    value: '${state.bestStreak} days',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        backgroundColor:
                            Theme.of(context).colorScheme.surface,
                        title: const Text('Reset this week?'),
                        content: const Text(
                          'This will clear all completed days for the selected week.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(false),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(true),
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true && context.mounted) {
                      context.read<ProgressCubit>().resetSelectedWeek();
                    }
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset This Week'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Small pill showing a streak metric.
class StreakChip extends StatelessWidget {
  const StreakChip({super.key, required this.label, required this.value});

  final String label;
  final String value;

  /// Builds the streak chip.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
