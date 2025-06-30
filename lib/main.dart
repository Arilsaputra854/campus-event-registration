
import 'package:campus_event_registration/view/splash_screen_page.dart';
import 'package:campus_event_registration/viewmodel/splash_viewmodel.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

void main() => runApp(
  MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => SplashViewmodel())],
    child: const MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Event Registration',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashScreenPage(),
    );
  }
}
