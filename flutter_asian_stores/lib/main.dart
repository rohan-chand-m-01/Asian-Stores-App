import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/store_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoreProvider()),
      ],
      child: const AsianStoresApp(),
    ),
  );
}

class AsianStoresApp extends StatelessWidget {
  const AsianStoresApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asian Stores',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const RootScreen(),
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();

    if (_showSplash) {
      return SplashScreen(
        onDone: () {
          setState(() => _showSplash = false);
        },
      );
    }

    if (store.user == null) {
      return const AuthScreen();
    }

    return const MainNavigationScreen();
  }
}
