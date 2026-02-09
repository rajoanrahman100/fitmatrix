import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../progress/progress_cubit.dart';
import 'routine_card.dart';

/// Shows the single workout for the currently selected day.
class SelectedWorkout extends StatelessWidget {
  const SelectedWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressCubit, ProgressState>(
      builder: (context, state) {
        final selectedWeek = state.weeks[state.selectedWeek];
        final dayIndex = state.selectedDay;
        final day = selectedWeek.days[dayIndex];
        final isCompleted =
            state.completedByWeek[state.selectedWeek].contains(dayIndex);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Workout',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 10),
            RoutineCard(
              day: day,
              dayIndex: dayIndex,
              isCompleted: isCompleted,
              showEstimate: false,
              onToggle: () => context.read<ProgressCubit>().toggleDay(dayIndex),
            ),
          ],
        );
      },
    );
  }
}
