import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'router/app_routes.dart';
import 'router/app_router.dart';
import 'theme/raby_theme.dart';

class RabyApp extends StatelessWidget {
  const RabyApp({this.initialLocation, super.key});

  final String? initialLocation;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Raby',
      debugShowCheckedModeBanner: false,
      theme: RabyTheme.light,
      locale: const Locale('zh', 'CN'),
      supportedLocales: const [Locale('zh', 'CN'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      routerConfig: createAppRouter(
        initialLocation: initialLocation ?? AppRoutes.startup,
      ),
    );
  }
}
