import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:temp_app/screens/home_screen.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/activity_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';
import 'services/firebase_service.dart';
import 'services/user_service.dart';
import 'screens/auth/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..init()),
        ChangeNotifierProvider(create: (_) => ActivityProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final provider = ProfileProvider();
            provider
                .initializeProfile(); // This is now async but we don't need to await here
            return provider;
          },
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider<UserService>(
          create: (_) => UserService(),
        ),
      ],
      builder: (context, child) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          title: 'E-Waste Management',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFFF6FDF7),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2E7D32), // Dark Green
              primary: const Color(0xFF2E7D32),
              secondary: const Color(0xFF66BB6A),
              background: const Color(0xFFF6FDF7),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              prefixIconColor: const Color(0xFF2E7D32),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xFF2E7D32), width: 2),
              ),
            ),
            useMaterial3: true,
          ),
          darkTheme: themeProvider.currentTheme,
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const SplashScreen(),
        );
      },
    );
  }
}

Future<void> main() async {
  await dotenv.load(fileName: ".env");
}
