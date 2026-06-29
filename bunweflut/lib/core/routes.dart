import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash       = '/';
  static const String login        = '/login';
  static const String home         = '/home';

  static Map<String, WidgetBuilder> get routes => {
    splash: (_) => const SplashScreen(),
    login:  (_) => const LoginScreen(),
    home:   (_) => const HomeScreen(),
  };
}
