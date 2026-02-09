import 'dart:convert';

import 'package:fitmatrix/models/workout_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/workout_data.dart';

/// Immutable UI state for progress tracking.
class ProgressState {
  const ProgressState({
    required this.weeks,
    required this.selectedWeek,
    required this.selectedDay,
    required this.programStartDate,
    required this.completedByWeek,
  });

  final List<WorkoutWeek> weeks;
  final int selectedWeek;
  final int selectedDay;
  final DateTime programStartDate;
  final List<Set<int>> completedByWeek;

  /// Counts weeks where every day is marked completed.
  int get completedWeekCount {
    var count = 0;
    for (var i = 0; i < weeks.length; i++) {
      if (completedByWeek[i].length == weeks[i].days.length) {
        count++;
      }
    }
    return count;
  }

  /// Calculates the latest consecutive completion streak.
  int get currentStreak {
    final completed = _flattenCompletion();
    if (completed.isEmpty) {
      return 0;
    }
    var lastCompletedIndex = completed.lastIndexOf(true);
    if (lastCompletedIndex == -1) {
      return 0;
    }
    var streak = 0;
    for (var i = lastCompletedIndex; i >= 0; i--) {
      if (completed[i]) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  /// Calculates the best historical completion streak.
  int get bestStreak {
    final completed = _flattenCompletion();
    var best = 0;
    var current = 0;
    for (final isDone in completed) {
      if (isDone) {
        current++;
        if (current > best) {
          best = current;
        }
      } else {
        current = 0;
      }
    }
    return best;
  }

  /// Flattens weekly completion into a single list for streak math.
  List<bool> _flattenCompletion() {
    final flattened = <bool>[];
    for (var weekIndex = 0; weekIndex < weeks.length; weekIndex++) {
      final weekDays = weeks[weekIndex].days.length;
      final completedSet = completedByWeek[weekIndex];
      for (var dayIndex = 0; dayIndex < weekDays; dayIndex++) {
        flattened.add(completedSet.contains(dayIndex));
      }
    }
    return flattened;
  }

  /// Creates a new state with selective overrides.
  ProgressState copyWith({
    int? selectedWeek,
    int? selectedDay,
    DateTime? programStartDate,
    List<Set<int>>? completedByWeek,
  }) {
    return ProgressState(
      weeks: weeks,
      selectedWeek: selectedWeek ?? this.selectedWeek,
      selectedDay: selectedDay ?? this.selectedDay,
      programStartDate: programStartDate ?? this.programStartDate,
      completedByWeek: completedByWeek ?? this.completedByWeek,
    );
  }
}

/// Manages progress, selections, and local persistence.
class ProgressCubit extends Cubit<ProgressState> {
  /// Internal constructor used by the factory to inject dependencies.
  ProgressCubit._({required this.prefs, required List<WorkoutWeek> weeks})
    : super(
        ProgressState(
          weeks: weeks,
          selectedWeek: 0,
          selectedDay: WorkoutData.indexForWeekday(DateTime.now().weekday) ?? 0,
          programStartDate: _defaultProgramStartDate(),
          completedByWeek: List<Set<int>>.generate(weeks.length, (_) => <int>{}),
        ),
      );

  /// Creates a cubit wired to shared preferences and workout data.
  factory ProgressCubit.withPrefs({required SharedPreferences prefs, required List<WorkoutWeek> weeks}) {
    return ProgressCubit._(prefs: prefs, weeks: weeks);
  }

  final SharedPreferences prefs;

  static const _selectedWeekKey = 'fitmatrix_selected_week';
  static const _selectedDayKey = 'fitmatrix_selected_day';
  static const _programStartKey = 'fitmatrix_program_start';
  static const _completedKey = 'fitmatrix_completed_days';

  /// Loads saved progress and selection state from local storage.
  void loadFromPrefs() {
    final savedWeek = prefs.getInt(_selectedWeekKey);
    final savedDay = prefs.getInt(_selectedDayKey);
    final savedStart = prefs.getString(_programStartKey);
    final savedJson = prefs.getString(_completedKey);

    List<Set<int>> completed = state.completedByWeek;
    if (savedJson != null) {
      try {
        final decoded = jsonDecode(savedJson) as List<dynamic>;
        completed = decoded.map((week) => (week as List<dynamic>).map((day) => day as int).toSet()).toList();
      } catch (_) {
        completed = state.completedByWeek;
      }
    }

    if (completed.length != state.weeks.length) {
      completed = List<Set<int>>.generate(state.weeks.length, (_) => <int>{});
    }

    final maxDayIndex = WorkoutData.weekdayLabels.length - 1;
    final resolvedDay = savedDay != null && savedDay >= 0 && savedDay <= maxDayIndex ? savedDay : state.selectedDay;
    final resolvedStart = savedStart != null ? DateTime.tryParse(savedStart) : state.programStartDate;
    if (savedStart == null && resolvedStart != null) {
      prefs.setString(_programStartKey, resolvedStart.toIso8601String());
    }

    emit(state.copyWith(
      selectedWeek: savedWeek ?? state.selectedWeek,
      selectedDay: resolvedDay,
      programStartDate: resolvedStart ?? state.programStartDate,
      completedByWeek: completed,
    ));
  }

  /// Updates the selected week and resets the selected day to today.
  void selectWeek(int index) {
    final todayIndex = WorkoutData.indexForWeekday(DateTime.now().weekday);
    final resolvedDay = todayIndex ?? 0;
    emit(state.copyWith(selectedWeek: index, selectedDay: resolvedDay));
    prefs.setInt(_selectedWeekKey, index);
    prefs.setInt(_selectedDayKey, resolvedDay);
  }

  /// Updates the program start date and persists it.
  void setProgramStartDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    emit(state.copyWith(programStartDate: normalized));
    prefs.setString(_programStartKey, normalized.toIso8601String());
  }

  /// Selects a week/day based on a calendar date in the program range.
  void selectByDate(DateTime date) {
    final mapping = mapDateToProgram(date);
    if (mapping == null) {
      return;
    }
    emit(state.copyWith(
      selectedWeek: mapping.weekIndex,
      selectedDay: mapping.dayIndex,
    ));
  }

  /// Sets the active day within the currently selected week.
  void selectDay(int index) {
    emit(state.copyWith(selectedDay: index));
    prefs.setInt(_selectedDayKey, index);
  }

  /// Toggles completion for a day in the selected week.
  void toggleDay(int dayIndex) {
    final updated = List<Set<int>>.generate(state.completedByWeek.length, (index) {
      return {...state.completedByWeek[index]};
    });
    final weekSet = updated[state.selectedWeek];
    if (weekSet.contains(dayIndex)) {
      weekSet.remove(dayIndex);
    } else {
      weekSet.add(dayIndex);
    }
    emit(state.copyWith(completedByWeek: updated));
    prefs.setString(_completedKey, _encodeCompleted(updated));
  }

  /// Clears all completions in the selected week.
  void resetSelectedWeek() {
    final updated = List<Set<int>>.generate(state.completedByWeek.length, (index) {
      return {...state.completedByWeek[index]};
    });
    updated[state.selectedWeek] = <int>{};
    emit(state.copyWith(completedByWeek: updated));
    prefs.setString(_completedKey, _encodeCompleted(updated));
  }

  /// Forces a day to completed or not completed.
  void setDayCompleted(int dayIndex, bool isCompleted) {
    final updated = List<Set<int>>.generate(state.completedByWeek.length, (index) {
      return {...state.completedByWeek[index]};
    });
    final weekSet = updated[state.selectedWeek];
    if (isCompleted) {
      weekSet.add(dayIndex);
    } else {
      weekSet.remove(dayIndex);
    }
    emit(state.copyWith(completedByWeek: updated));
    prefs.setString(_completedKey, _encodeCompleted(updated));
  }

  /// Serializes completion state to JSON for persistence.
  String _encodeCompleted(List<Set<int>> completed) {
    final encoded = completed.map((week) => week.toList()).toList();
    return jsonEncode(encoded);
  }

  /// Maps a calendar date to the program week/day indices.
  ProgramDateMapping? mapDateToProgram(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    final start = state.programStartDate;
    final diffDays = normalized.difference(start).inDays;
    if (diffDays < 0) {
      return null;
    }
    final weekIndex = diffDays ~/ 7;
    final dayIndex = diffDays % 7;
    if (weekIndex < 0 || weekIndex >= state.weeks.length) {
      return null;
    }
    if (dayIndex >= state.weeks.first.days.length) {
      return null;
    }
    return ProgramDateMapping(weekIndex: weekIndex, dayIndex: dayIndex);
  }

  /// Builds a daily completion series from the program start date.
  List<DailyProgressPoint> buildDailyProgressSeries() {
    final points = <DailyProgressPoint>[];
    final totalWeeks = state.weeks.length;
    final daysPerWeek = state.weeks.first.days.length;
    final totalDays = totalWeeks * daysPerWeek;

    var completedCount = 0;
    for (var dayOffset = 0; dayOffset < totalDays; dayOffset++) {
      final weekIndex = dayOffset ~/ 7;
      final dayIndex = dayOffset % 7;
      final isCompleted = state.completedByWeek[weekIndex].contains(dayIndex);
      if (isCompleted) {
        completedCount++;
      }
      final date =
          state.programStartDate.add(Duration(days: dayOffset));
      points.add(DailyProgressPoint(
        date: date,
        completedTotal: completedCount,
        completedToday: isCompleted,
      ));
    }
    return points;
  }

  static DateTime _defaultProgramStartDate() {
    final today = DateTime.now();
    final normalized = DateTime(today.year, today.month, today.day);
    final diff = (normalized.weekday - DateTime.saturday) % 7;
    return normalized.subtract(Duration(days: diff));
  }
}

/// Maps a calendar date to the training week and day indices.
class ProgramDateMapping {
  const ProgramDateMapping({required this.weekIndex, required this.dayIndex});

  final int weekIndex;
  final int dayIndex;
}

/// Single point on the daily progress trend line.
class DailyProgressPoint {
  const DailyProgressPoint({
    required this.date,
    required this.completedTotal,
    required this.completedToday,
  });

  final DateTime date;
  final int completedTotal;
  final bool completedToday;
}
