import 'package:flutter/material.dart';
import 'client.dart';
import 'screens/auth_screen.dart';
import 'screens/pact_list_screen.dart';
import 'theme/streak_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  runApp(const StreakBondApp());
}

class StreakBondApp extends StatelessWidget {
  const StreakBondApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StreakBond',
      debugShowCheckedModeBanner: false,
      theme: buildStreakTheme(),
      darkTheme: buildStreakTheme(),
      themeMode: ThemeMode.dark,
      home: const AuthScreen(
        child: PactListScreen(),
      ),
    );
  }
}
