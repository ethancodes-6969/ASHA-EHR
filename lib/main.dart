import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/di/service_locator.dart';
import 'presentation/app.dart';

import 'package:get_it/get_it.dart';
import 'package:asha_ehr/presentation/dashboard/dashboard_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!GetIt.instance.isRegistered<DashboardViewModel>()) {
    setupServiceLocator();
  }


  // 1. Global Error Logging (Console only for MVP)
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  // 2. Friendly UI for crashes
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mood_bad, size: 48, color: Colors.indigo),
            const SizedBox(height: 16),
            const Text(
              "Don't Worry, Your Data is Safe",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Something technically wrong happened. Please go back or restart the app.",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  };

  runApp(const AshaApp());
}
