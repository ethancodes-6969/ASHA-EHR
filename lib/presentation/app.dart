import 'package:flutter/material.dart';
import 'package:asha_ehr/presentation/dashboard/dashboard_screen.dart';

class AshaApp extends StatelessWidget {
  const AshaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASHA EHR',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}
