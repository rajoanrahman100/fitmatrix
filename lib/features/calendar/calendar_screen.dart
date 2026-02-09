import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../progress/progress_cubit.dart';

/// Calendar view that syncs dates with the 7-week workout plan.
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _visibleMonth;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _visibleMonth = DateTime(today.year, today.month);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Calendar')),
      body: BlocBuilder<ProgressCubit, ProgressState>(
        builder: (context, state) {
          final start = state.programStartDate;
          final daysInMonth = DateUtils.getDaysInMonth(
            _visibleMonth.year,
            _visibleMonth.month,
          );
          final firstWeekday =
              DateTime(_visibleMonth.year, _visibleMonth.month, 1).weekday;
          final offset = (firstWeekday + 6) % 7; // Monday=1 -> 0 index

          return Column(
            children: [
              _CalendarHeader(
                month: _visibleMonth,
                onPrevious: () => setState(() {
                  _visibleMonth =
                      DateTime(_visibleMonth.year, _visibleMonth.month - 1);
                }),
                onNext: () => setState(() {
                  _visibleMonth =
                      DateTime(_visibleMonth.year, _visibleMonth.month + 1);
                }),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Program start: ${_formatDate(start)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: start,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null && context.mounted) {
                          context
                              .read<ProgressCubit>()
                              .setProgramStartDate(picked);
                          setState(() {
                            _visibleMonth =
                                DateTime(picked.year, picked.month);
                          });
                        }
                      },
                      icon: const Icon(Icons.edit_calendar),
                      label: const Text('Set'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              _WeekdayRow(),
              const SizedBox(height: 6),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: offset + daysInMonth,
                  itemBuilder: (context, index) {
                    if (index < offset) {
                      return const SizedBox.shrink();
                    }

                    final dayNumber = index - offset + 1;
                    final date = DateTime(
                      _visibleMonth.year,
                      _visibleMonth.month,
                      dayNumber,
                    );

                    final mapping =
                        context.read<ProgressCubit>().mapDateToProgram(date);
                    final isScheduled = mapping != null;
                    final isCompleted = isScheduled &&
                        state.completedByWeek[mapping.weekIndex]
                            .contains(mapping.dayIndex);
                    final isToday = DateUtils.isSameDay(date, DateTime.now());

                    return _CalendarCell(
                      date: date,
                      isScheduled: isScheduled,
                      isCompleted: isCompleted,
                      isToday: isToday,
                      onTap: isScheduled
                          ? () => context.read<ProgressCubit>().selectByDate(date)
                          : null,
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _LegendDot(color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 6),
                    const Text('Scheduled'),
                    const SizedBox(width: 14),
                    _LegendDot(color: Theme.of(context).colorScheme.secondary),
                    const SizedBox(width: 6),
                    const Text('Completed'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }
}

String _formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.month,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final label = '${_monthName(month.month)} ${month.year}';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: onPrevious,
            icon: const Icon(Icons.chevron_left),
          ),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          IconButton(
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const names = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return names[month - 1];
  }
}

class _WeekdayRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final label in labels)
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white70,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CalendarCell extends StatelessWidget {
  const _CalendarCell({
    required this.date,
    required this.isScheduled,
    required this.isCompleted,
    required this.isToday,
    this.onTap,
  });

  final DateTime date;
  final bool isScheduled;
  final bool isCompleted;
  final bool isToday;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isToday
        ? Theme.of(context).colorScheme.primary
        : Colors.white12;
    final background = isCompleted
        ? Theme.of(context).colorScheme.secondary
        : isScheduled
            ? Theme.of(context).colorScheme.surface
            : Colors.white.withOpacity(0.04);
    final textColor = isCompleted ? Colors.black : Colors.white70;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isToday ? 2 : 1),
        ),
        alignment: Alignment.center,
        child: Text(
          '${date.day}',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
