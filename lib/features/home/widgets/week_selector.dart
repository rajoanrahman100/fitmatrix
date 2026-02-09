import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../progress/progress_cubit.dart';

/// Horizontal selector for the 7 weeks.
class WeekSelector extends StatelessWidget {
  const WeekSelector({super.key});

  /// Builds the week pill list.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressCubit, ProgressState>(
      builder: (context, state) {
        return SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: state.weeks.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final isSelected = index == state.selectedWeek;
              return GestureDetector(
                onTap: () => context.read<ProgressCubit>().selectWeek(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      'Week ${index + 1}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: isSelected
                                ? Colors.black
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
