import 'package:app/screen/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    // Create an animation controller and animation for scaling the icon
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Wait for 2 seconds before navigating to the login screen
    Future.delayed(Duration(seconds: 2), () {
      Get.offAll(LoginScreen()); // Navigate to Login Screen
    });

    // Start the animation
    _controller.forward();

    // Make the text and icon visible with some delay
    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent, // Match app's theme color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Car Icon with Scale
            ScaleTransition(
              scale: _animation,
              child: Icon(
                Icons.directions_car,
                size: 100,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            // Animated Text for App Name
            AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: Text(
                'Car Baazar',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
