import 'package:flutter/material.dart';

import 'widgets/background_glow.dart';
import 'widgets/header_section.dart';
import 'widgets/week_selector.dart';
import 'widgets/week_calendar.dart';
import 'widgets/weekly_split.dart';
import 'widgets/selected_workout.dart';
import 'all_workouts_screen.dart';
import '../calendar/calendar_screen.dart';
import '../stats/stats_screen.dart';
import '../progress/progress_panel.dart';

/// Main dashboard screen that composes all home widgets.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// Builds the FitMatrix home layout.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundGlow(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderSection(),
                  const SizedBox(height: 16),
                  const WeekSelector(),
                  const SizedBox(height: 18),
                  const ProgressPanel(),
                  const SizedBox(height: 16),
                  const WeekCalendar(),
                  const SizedBox(height: 12),
                  const SelectedWorkout(),
                  const SizedBox(height: 16),
                  const WeeklySplit(),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CalendarScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.calendar_month),
                      label: const Text('Open Calendar'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const StatsScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.bar_chart),
                      label: const Text('View Progress Stats'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AllWorkoutsScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.view_list),
                      label: const Text('View All Workouts'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
