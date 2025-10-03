import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modern_flutter_app/router/app_router.dart';
import 'package:modern_flutter_app/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.interTextTheme();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Modern Flutter App',
      themeMode: ThemeMode.system,
      theme: AppTheme.light(textTheme),
      darkTheme: AppTheme.dark(textTheme),
      routerConfig: AppRouter.router,
    );
  }
}
