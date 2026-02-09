import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/fitmatrix_app.dart';

/// App entry point that prepares local storage before rendering UI.
Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  await Future<void>.delayed(const Duration(milliseconds: 1500));
  final prefs = await SharedPreferences.getInstance();
  FlutterNativeSplash.remove();
  runApp(FitMatrixApp(prefs: prefs));
}
