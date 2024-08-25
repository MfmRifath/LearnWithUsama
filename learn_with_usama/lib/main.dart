import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learn_with_usama/screens/Home.dart';
import 'package:learn_with_usama/screens/LoginScreen.dart';
import 'package:learn_with_usama/screens/RegisterScreen.dart';
import 'screens/startScreen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyC113nrM0VS4kN_wpKlG5oiF5RrjLKhHUo',
        appId: '1:451011012873:android:fb7b5b5e361460935fcbd8',
        messagingSenderId: '451011012873',
        projectId: 'leanwithusama',
        storageBucket: 'leanwithusama.appspot.com',
      )
  );

  runApp(learnWithUsama());
}

class learnWithUsama extends StatelessWidget {
  const learnWithUsama({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      home: StartScreen(),
      initialRoute: StartScreen.id,
      routes: {
        StartScreen.id: (context) => StartScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        Home.id: (context) => Home()
      },
    );
  }
}
