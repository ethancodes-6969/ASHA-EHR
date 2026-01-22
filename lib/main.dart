import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'core/di/service_locator.dart';
import 'presentation/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  setupServiceLocator();


  runApp(const AshaApp());
}
