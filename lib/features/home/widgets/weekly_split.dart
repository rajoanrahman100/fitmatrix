import 'package:flutter/material.dart';

/// Static summary of the weekly training split.
class WeeklySplit extends StatelessWidget {
  const WeeklySplit({super.key});

  List<Map<String, String>> _buildSplit() {
    return const [
      {'day': 'Saturday', 'label': 'Push', 'focus': 'Chest/Shoulders/Triceps'},
      {'day': 'Sunday', 'label': 'Pull', 'focus': 'Back/Biceps/Rear Delts'},
      {'day': 'Monday', 'label': 'Legs', 'focus': 'Quads/Hamstrings/Glutes/Calves'},
      {'day': 'Tuesday', 'label': 'Push', 'focus': 'Volume Focus'},
      {'day': 'Wednesday', 'label': 'Pull', 'focus': 'Strength Focus'},
      {'day': 'Thursday', 'label': 'Recovery', 'focus': 'Rest / Active Recovery'},
    ];
  }

  /// Builds the split summary card.
  @override
  Widget build(BuildContext context) {
    final items = _buildSplit();
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
            'Weekly Split (Saturday → Thursday)',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final item in items)
                Container(
                  width: 160,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['day']!,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.16),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item['label']!,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['focus']!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
