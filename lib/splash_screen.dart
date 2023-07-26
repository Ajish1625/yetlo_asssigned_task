import 'dart:async';

import 'package:flutter/material.dart';
import 'package:interview_task/views/HomePage/home_page.dart';

import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for 3 seconds and then navigate to the home page

    startTime();
  }

  startTime() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [
              0.1,
              0.4,
              0.6,
              0.9,
            ],
            colors: [
              Colors.deepPurpleAccent,
              Colors.yellowAccent,
              Colors.cyanAccent,
              Colors.deepOrangeAccent,
            ],
          ),
        ),
        child: Center(
          child: Image.asset(
              'assets/unnamed.png'), // Replace 'your_image.jpg' with the actual image filename
        ),
      ),
    );
  }
}
