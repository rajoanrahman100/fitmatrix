import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../progress/progress_cubit.dart';
import 'routine_card.dart';

/// Scrollable list of workout day cards.
class RoutineList extends StatelessWidget {
  const RoutineList({super.key});

  /// Builds the list ordered from the selected day.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressCubit, ProgressState>(
      builder: (context, state) {
        final selectedWeek = state.weeks[state.selectedWeek];
        final totalDays = selectedWeek.days.length;
        return ListView.separated(
          key: ValueKey('week-${state.selectedWeek}'),
          itemCount: totalDays,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final displayIndex = (state.selectedDay + index) % totalDays;
            final day = selectedWeek.days[displayIndex];
            final isCompleted =
                state.completedByWeek[state.selectedWeek].contains(displayIndex);
            return RoutineCard(
              key: ValueKey('week-${state.selectedWeek}-day-$displayIndex'),
              day: day,
              dayIndex: displayIndex,
              isCompleted: isCompleted,
              onToggle: () =>
                  context.read<ProgressCubit>().toggleDay(displayIndex),
            );
          },
        );
      },
    );
  }
}
