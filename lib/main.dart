import 'package:flutter/material.dart';
import 'package:asha_ehr/core/di/service_locator.dart';
import 'package:asha_ehr/presentation/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  runApp(const AshaApp());
}
