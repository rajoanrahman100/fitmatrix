import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/workout_models.dart';
import '../progress/progress_cubit.dart';

/// Detail view listing all sections and exercises for a day.
class WorkoutDetailScreen extends StatefulWidget {
  const WorkoutDetailScreen({
    super.key,
    required this.day,
    required this.dayIndex,
  });

  final WorkoutDay day;
  final int dayIndex;

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(milliseconds: 700));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  /// Builds the detail screen with exercises and action button.
  @override
  Widget build(BuildContext context) {
    final estimatedMinutes = _estimateMinutes(widget.day);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.day.title),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        children: [
          Text(
            widget.day.subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,fontSize: 18,fontWeight: FontWeight.w600
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                label: Text('~$estimatedMinutes min'),
                avatar: const Icon(Icons.timer, size: 16),
                backgroundColor: Theme.of(context).colorScheme.surface,
                side: const BorderSide(color: Colors.white12),
                labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white70,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          for (final section in widget.day.sections)
            Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                  const SizedBox(height: 10),
                  for (final exercise in section.exercises)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.bolt,
                              size: 14, color: Colors.white54),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${exercise.name} — ${exercise.detail}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () async {
                context
                    .read<ProgressCubit>()
                    .setDayCompleted(widget.dayIndex, true);
                await _showSuccessOverlay(context);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.check_circle),
              label: const Text('Mark All Done'),
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a brief success overlay with confetti after completion.
  Future<void> _showSuccessOverlay(BuildContext context) async {
    _confettiController.play();

    final dialogFuture = showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'completed',
      barrierColor: Colors.black54,
      pageBuilder: (_, __, ___) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.2,
              numberOfParticles: 16,
              gravity: 0.8,
              shouldLoop: false,
              colors: const [
                Color(0xFF56C6FF),
                Color(0xFFFFC36A),
                Color(0xFF9DFFB0),
                Color(0xFFFF7A7A),
              ],
            ),
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child:
                          const Icon(Icons.check, color: Colors.black, size: 36),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Workout Completed',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Great job finishing today’s session.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: curved, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 220),
    );

    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    await dialogFuture;
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
          minutes += sets * 2.5;
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
