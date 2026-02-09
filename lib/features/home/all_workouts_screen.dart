import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../progress/progress_cubit.dart';
import 'widgets/routine_card.dart';

/// Full list of workouts for the selected week.
class AllWorkoutsScreen extends StatelessWidget {
  const AllWorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Workouts'),
      ),
      body: BlocBuilder<ProgressCubit, ProgressState>(
        builder: (context, state) {
          final selectedWeek = state.weeks[state.selectedWeek];
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            itemCount: selectedWeek.days.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final day = selectedWeek.days[index];
              final isCompleted =
                  state.completedByWeek[state.selectedWeek].contains(index);
              return RoutineCard(
                day: day,
                dayIndex: index,
                isCompleted: isCompleted,
                onToggle: () =>
                    context.read<ProgressCubit>().toggleDay(index),
              );
            },
          );
        },
      ),
    );
  }
}
