import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/workout_data.dart';
import '../../progress/progress_cubit.dart';

/// Calendar row for Saturday–Thursday with selection and completion.
class WeekCalendar extends StatelessWidget {
  const WeekCalendar({super.key});

  /// Builds the calendar tiles for the selected week.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressCubit, ProgressState>(
      builder: (context, state) {
        final labels = WorkoutData.weekdayLabels;
        final completed = state.completedByWeek[state.selectedWeek];
        final todayIndex = WorkoutData.indexForWeekday(DateTime.now().weekday);
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Week Calendar',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(labels.length, (index) {
                  final isDone = completed.contains(index);
                  final isToday = todayIndex == index;
                  final isSelected = state.selectedDay == index;
                  return GestureDetector(
                    onTap: () => context.read<ProgressCubit>().selectDay(index),
                    onLongPress: () =>
                        context.read<ProgressCubit>().toggleDay(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 40,
                      height: 54,
                      decoration: BoxDecoration(
                        color: isDone
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDone
                              ? Theme.of(context).colorScheme.secondary
                              : isToday
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.white12,
                          width: isSelected ? 2.4 : (isToday ? 2 : 1),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            labels[index],
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDone ? Colors.black : Colors.white70,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Icon(
                            isDone ? Icons.check_circle : Icons.circle_outlined,
                            size: 18,
                            color: isDone ? Colors.black : Colors.white38,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
