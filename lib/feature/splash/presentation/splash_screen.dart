import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startApp();
  }

  Future<void> _startApp() async {
    await Future.delayed(const Duration(seconds: 3));

    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.secondaryGreen.withOpacity(0.8);
    final secondaryColor = AppColors.secondaryGreen.withOpacity(0.4);
    final fixedColor = AppColors.secondaryGreen.withOpacity(0.4);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [fixedColor, primaryColor, secondaryColor],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
