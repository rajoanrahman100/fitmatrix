import 'package:flutter/material.dart';

/// Nutrition guidance screen based on the provided 7-week plan.
class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nutrition Guide'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Training Days'),
              Tab(text: 'Rest Days'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _NutritionTab(
              title: 'Training Day Targets',
              macros: const [
                _MacroItem(label: 'Calories', value: '2,200–2,400'),
                _MacroItem(label: 'Protein', value: '150–165g'),
                _MacroItem(label: 'Carbs', value: '250–280g'),
                _MacroItem(label: 'Fats', value: '50–60g'),
              ],
              meals: _trainingMeals,
            ),
            _NutritionTab(
              title: 'Rest Day Targets',
              macros: const [
                _MacroItem(label: 'Calories', value: '1,800–2,000'),
                _MacroItem(label: 'Protein', value: '150–165g'),
                _MacroItem(label: 'Carbs', value: '120–150g'),
                _MacroItem(label: 'Fats', value: '65–75g'),
              ],
              meals: _restMeals,
              callouts: const [
                _Callout(
                  title: 'Carb Reductions',
                  body:
                      'Breakfast: 1 roti instead of 2 (or 1/2 cup oats).\nLunch: 1 cup rice instead of 1.5 cups.\nDinner: 1 roti instead of 2, or skip rice.',
                ),
                _Callout(
                  title: 'Healthy Fats Boost',
                  body:
                      'Add extra nuts, 1–2 tbsp peanut butter, use a little more olive oil, or add avocado if available.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NutritionTab extends StatelessWidget {
  const _NutritionTab({
    required this.title,
    required this.macros,
    required this.meals,
    this.callouts = const [],
  });

  final String title;
  final List<_MacroItem> macros;
  final List<_MealItem> meals;
  final List<_Callout> callouts;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 20),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _MacroGrid(items: macros),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Daily Meal Structure',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: _MealTimeline(meals: meals),
        ),
        if (callouts.isNotEmpty) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Rest Day Adjustments',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              children: callouts
                  .map((item) => _AdjustmentCard(callout: item))
                  .toList(),
            ),
          ),
        ],
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _SectionHeader('Bengali / South Asian Options'),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _KeyValueList(items: _bengaliOptions),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _SectionHeader('Hydration & Supplements'),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _KeyValueList(items: _hydrationSupplements),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _SectionHeader('Carb Cycling Schedule'),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _CarbScheduleTable(),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _SectionHeader('Progress Tracking'),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _KeyValueList(items: _progressTracking),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _SectionHeader('Adjustment Rules'),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _KeyValueList(items: _adjustmentRules),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _SectionHeader('Meal Prep Tips'),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _KeyValueList(items: _mealPrepTips),
        ),
      ],
    );
  }
}

class _MacroGrid extends StatelessWidget {
  const _MacroGrid({required this.items});

  final List<_MacroItem> items;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.6,
      children: items.map((item) => _MacroCard(item: item)).toList(),
    );
  }
}

class _MacroCard extends StatelessWidget {
  const _MacroCard({required this.item});

  final _MacroItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              Text(
                item.value,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  const _MealCard({required this.meal});

  final _MealItem meal;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12, bottom: 10),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  meal.time,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  meal.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...meal.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (meal.macros != null) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Macros: ${meal.macros}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white70,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MealTimeline extends StatelessWidget {
  const _MealTimeline({required this.meals});

  final List<_MealItem> meals;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: meals.map((meal) => _MealCard(meal: meal)).toList(),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _KeyValueList extends StatelessWidget {
  const _KeyValueList({required this.items});

  final List<MapEntry<String, String>> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                        children: [
                          TextSpan(
                            text: '${item.key}: ',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextSpan(text: item.value),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _CalloutCard extends StatelessWidget {
  const _CalloutCard({required this.callout});

  final _Callout callout;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            callout.title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            callout.body,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
          ),
        ],
      ),
    );
  }
}

class _AdjustmentCard extends StatelessWidget {
  const _AdjustmentCard({required this.callout});

  final _Callout callout;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12, bottom: 10),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  callout.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...callout.body.split('\\n').map(
                (line) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    line,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _CarbScheduleTable extends StatelessWidget {
  const _CarbScheduleTable();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: _carbSchedule
            .map(
              (row) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        row.day,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        row.type,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        row.carbs,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _MacroItem {
  const _MacroItem({
    required this.label,
    required this.value,
    this.icon = Icons.local_fire_department,
  });

  final String label;
  final String value;
  final IconData icon;
}

class _MealItem {
  const _MealItem({
    required this.title,
    required this.time,
    required this.items,
    this.macros,
  });

  final String title;
  final String time;
  final List<String> items;
  final String? macros;
}

class _Callout {
  const _Callout({required this.title, required this.body});

  final String title;
  final String body;
}

class _CarbRow {
  const _CarbRow({required this.day, required this.type, required this.carbs});

  final String day;
  final String type;
  final String carbs;
}

const List<_MealItem> _trainingMeals = [
  _MealItem(
    title: 'Meal 1 - Breakfast',
    time: '7:00 AM',
    items: [
      '3 whole eggs + 2 egg whites (scrambled/omelette)',
      '2 whole wheat roti OR 1 cup oats',
      '1 banana',
      'Black coffee/green tea',
    ],
    macros: '35g protein, 50g carbs, 18g fat | ~480 cal',
  ),
  _MealItem(
    title: 'Meal 2 - Mid-Morning Snack',
    time: '10:30 AM',
    items: [
      '1 cup Greek yogurt OR regular yogurt',
      '1 apple or orange',
      '10-12 almonds',
    ],
    macros: '15g protein, 30g carbs, 8g fat | ~250 cal',
  ),
  _MealItem(
    title: 'Meal 3 - Lunch',
    time: '1:00 PM',
    items: [
      '150g grilled chicken/fish OR 200g lean beef',
      '1.5 cups white/brown rice (cooked)',
      'Mixed vegetables (broccoli, beans, carrots)',
      'Side salad with 1 tsp olive oil',
    ],
    macros: '45g protein, 70g carbs, 12g fat | ~550 cal',
  ),
  _MealItem(
    title: 'Pre-Workout',
    time: '4:30 PM',
    items: [
      '2 whole wheat roti + 2 boiled eggs',
      'OR oats (50g) with protein powder (1 scoop)',
      '1 small banana',
    ],
    macros: '25g protein, 50g carbs, 8g fat | ~380 cal',
  ),
  _MealItem(
    title: 'Post-Workout Shake',
    time: '6:30 PM',
    items: [
      '2 dates',
      '1 banana',
      'Handful of cashews (10-12 nuts)',
      '300ml milk',
      'Optional: 1 scoop whey protein',
    ],
    macros: '30g protein, 65g carbs, 15g fat | ~500 cal',
  ),
  _MealItem(
    title: 'Meal 4 - Dinner',
    time: '8:30 PM',
    items: [
      '150g grilled chicken/fish',
      '1 cup rice OR 2 roti',
      'Dal (lentils) - 1 cup',
      'Vegetables (any curry/sabzi)',
      'Small salad',
    ],
    macros: '40g protein, 60g carbs, 10g fat | ~480 cal',
  ),
  _MealItem(
    title: 'Before Bed (Optional)',
    time: '10:30 PM',
    items: [
      '1 cup low-fat milk OR casein protein shake',
      '5-6 almonds',
    ],
    macros: '10g protein, 10g carbs, 6g fat | ~130 cal',
  ),
];

const List<_MealItem> _restMeals = [
  _MealItem(
    title: 'Meal 1 - Breakfast',
    time: '7:00 AM',
    items: [
      '3 whole eggs + 2 egg whites (scrambled/omelette)',
      '1 whole wheat roti OR 1/2 cup oats',
      '1 banana',
      'Black coffee/green tea',
    ],
    macros: 'Lower carbs, steady protein',
  ),
  _MealItem(
    title: 'Meal 2 - Mid-Morning Snack',
    time: '10:30 AM',
    items: [
      '1 cup Greek yogurt OR regular yogurt',
      '1 apple or orange',
      '10-12 almonds',
    ],
  ),
  _MealItem(
    title: 'Meal 3 - Lunch',
    time: '1:00 PM',
    items: [
      '150g grilled chicken/fish OR 200g lean beef',
      '1 cup rice (cooked)',
      'Mixed vegetables',
      'Side salad with olive oil',
    ],
  ),
  _MealItem(
    title: 'Meal 4 - Dinner',
    time: '8:30 PM',
    items: [
      '150g grilled chicken/fish',
      '1 roti OR skip rice',
      'Dal (lentils) - 1 cup',
      'Vegetables (any curry/sabzi)',
    ],
  ),
];

const List<MapEntry<String, String>> _bengaliOptions = [
  MapEntry('Protein',
      'Hilsa, Rui, Katla, chicken breast/thigh, lean beef, eggs, paneer, doi, dal'),
  MapEntry('Carbs', 'Bhat (white/brown rice), roti, alu, chira, oats, suji'),
  MapEntry('Vegetables', 'Shak, begun, lau, phulkopi, broccoli, beans'),
  MapEntry('Healthy Fats', 'Mustard oil (moderate), nuts, olive oil'),
];

const List<MapEntry<String, String>> _hydrationSupplements = [
  MapEntry('Water', '3–4 liters daily, more on training days'),
  MapEntry('Whey Protein', 'Add to post-workout shake if needed'),
  MapEntry('Creatine', '5g daily'),
  MapEntry('Multivitamin', 'Once daily'),
  MapEntry('Fish Oil', 'If not eating fish regularly'),
  MapEntry('Vitamin D3', 'Especially important in Bangladesh'),
];

const List<_CarbRow> _carbSchedule = [
  _CarbRow(day: 'Monday', type: 'High', carbs: '280g'),
  _CarbRow(day: 'Tuesday', type: 'High', carbs: '270g'),
  _CarbRow(day: 'Wednesday', type: 'High', carbs: '280g'),
  _CarbRow(day: 'Thursday', type: 'High', carbs: '270g'),
  _CarbRow(day: 'Friday', type: 'High', carbs: '260g'),
  _CarbRow(day: 'Saturday', type: 'Low', carbs: '130g'),
  _CarbRow(day: 'Sunday', type: 'Low', carbs: '140g'),
];

const List<MapEntry<String, String>> _progressTracking = [
  MapEntry('Weight', 'Every Monday morning (fasted)'),
  MapEntry('Photos', 'Front/side/back every 2 weeks'),
  MapEntry('Measurements', 'Waist, chest, arms every 2 weeks'),
  MapEntry('Strength', 'Track bench, squat, deadlift, OHP'),
];

const List<MapEntry<String, String>> _adjustmentRules = [
  MapEntry('Not losing fat', 'Reduce calories by 100–150 (cut carbs slightly)'),
  MapEntry('Losing strength', 'Increase calories by 100–150 (add carbs on training days)'),
  MapEntry('Losing too fast', 'Add 100–200 calories'),
];

const List<MapEntry<String, String>> _mealPrepTips = [
  MapEntry('Sunday prep', 'Cook chicken/fish in bulk, portion rice'),
  MapEntry('Eggs', 'Boil 10–12 eggs at once'),
  MapEntry('Nuts', 'Pre-portion in small containers'),
  MapEntry('Breakfast', 'Overnight oats for fast mornings'),
  MapEntry('Office', 'Keep protein powder for backup'),
];
