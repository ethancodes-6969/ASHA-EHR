import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:asha_ehr/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:asha_ehr/presentation/dashboard/dashboard_screen.dart';
import 'package:asha_ehr/presentation/settings/locale_provider.dart';

class AshaApp extends StatelessWidget {
  const AshaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: 'ASHA EHR',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
              useMaterial3: true,
            ),
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('hi'), // Hindi
              Locale('mr'), // Marathi
            ],
            home: const DashboardScreen(),
          );
        },
      ),
    );
  }
}
