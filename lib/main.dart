import 'package:campus_event_registration/view/home_page.dart';
import 'package:campus_event_registration/view/login_page.dart';
import 'package:campus_event_registration/view/onboarding_page.dart';
import 'package:campus_event_registration/view/register_page.dart';
import 'package:campus_event_registration/view/splash_screen_page.dart';
import 'package:campus_event_registration/viewmodel/splash_viewmodel.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() => runApp(
  MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => SplashViewmodel())],
    child: const MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // ✅ Ini hanya dibuat sekali, bukan tiap hot reload
  static final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const SplashScreenPage(),
        routes: <RouteBase>[
          GoRoute(
            path: 'onboarding',
            builder: (context, state) => const OnboardingPage(),
          ),
          GoRoute(
            path: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: 'login',
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: 'register',
            builder: (context, state) => const RegisterPage(),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router, // ⬅️ Pakai router yang tidak dibuat ulang
      title: 'Campus Event Registration',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
