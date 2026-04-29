import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamik Devs',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const Scaffold(
        body: Center(
          child: Text(
            'Dynamik Devs',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
