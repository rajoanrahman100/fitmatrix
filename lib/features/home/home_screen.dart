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
import '../achievements/achievements_screen.dart';
import '../photo/photo_progress_screen.dart';
import '../nutrition/nutrition_screen.dart';
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
                  const _QuickActions(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.35,
          children: [
            _ActionCard(
              title: 'Calendar',
              subtitle: 'Schedule view',
              icon: Icons.calendar_month,
              gradient: const [Color(0xFF56C6FF), Color(0xFF3B7BFF)],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CalendarScreen()),
              ),
            ),
            _ActionCard(
              title: 'Progress',
              subtitle: 'Stats & trends',
              icon: Icons.bar_chart,
              gradient: const [Color(0xFFFFC36A), Color(0xFFFF8A5C)],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const StatsScreen()),
              ),
            ),
            _ActionCard(
              title: 'Achievements',
              subtitle: 'Badges earned',
              icon: Icons.emoji_events,
              gradient: const [Color(0xFF9DFFB0), Color(0xFF4EDB8A)],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AchievementsScreen()),
              ),
            ),
            _ActionCard(
              title: 'All Workouts',
              subtitle: 'Full list',
              icon: Icons.view_list,
              gradient: const [Color(0xFFA78BFA), Color(0xFF7C5CFF)],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AllWorkoutsScreen()),
              ),
            ),
            _ActionCard(
              title: 'Photo Progress',
              subtitle: 'Front/side/back',
              icon: Icons.photo_camera,
              gradient: const [Color(0xFFFF7A7A), Color(0xFFB94B9B)],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PhotoProgressScreen()),
              ),
            ),
            _ActionCard(
              title: 'Nutrition',
              subtitle: 'Meal guidance',
              icon: Icons.restaurant_menu,
              gradient: const [Color(0xFF56C6FF), Color(0xFF1FB6FF)],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NutritionScreen()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.88),
                    ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
