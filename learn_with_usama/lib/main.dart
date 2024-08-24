import 'package:flutter/material.dart';
import 'screens/startScreen.dart';
void main() => runApp( learnWithUsama());


class learnWithUsama extends StatelessWidget {
  const learnWithUsama({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: startScreen(),
    );
  }
}
