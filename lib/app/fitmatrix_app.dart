import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/workout_data.dart';
import '../features/splash/splash_screen.dart';
import '../features/progress/progress_cubit.dart';
import '../theme/app_theme.dart';

/// Root widget that wires theme, state, and the initial route.
class FitMatrixApp extends StatelessWidget {
  const FitMatrixApp({super.key, required this.prefs});

  final SharedPreferences prefs;

  /// Builds the Material app shell and injects the progress cubit.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProgressCubit.withPrefs(
        prefs: prefs,
        weeks: WorkoutData.buildWeeks(),
      )..loadFromPrefs(),
      child: MaterialApp(
        title: 'FitMatrix',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const SplashScreen(),
      ),
    );
  }
}
