import 'package:campus_event_registration/view/home_page.dart';
import 'package:campus_event_registration/view/onboarding_page.dart';
import 'package:campus_event_registration/view/splash_screen_page.dart';
import 'package:campus_event_registration/viewmodel/splash_viewmodel.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreenPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/onboarding',
          builder: (BuildContext context, GoRouterState state) {
            return OnboardingPage();
          },
        ),
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) {
            return HomePage();
          },
        ),
      ],
    ),
  ],
);

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashViewmodel()),
      ],
      child: const MyApp(),
    ),);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Campus Event Registration',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
          
    );
  }
}
