import 'package:campus_event_registration/viewmodel/splash_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});  

  

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SplashViewmodel>(context, listen: false);

    Future.delayed( Duration(seconds: 2),() {
      if(vm.isLogged){
        context.go('/home');
      }else{
        context.go('/onboarding');
      }
      
    },);

    return Scaffold(
      body: Center(child: Text("Logo"),),
    );
  }
}