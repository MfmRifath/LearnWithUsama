import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learn_with_usama/root.dart';
import 'package:learn_with_usama/screens/CourseScreen.dart';
import 'package:learn_with_usama/screens/Home.dart';
import 'package:learn_with_usama/screens/LoginScreen.dart';
import 'package:learn_with_usama/screens/RegisterScreen.dart';
import 'package:learn_with_usama/screens/TheoryScreen.dart';
import 'package:learn_with_usama/screens/UnitsWidget.dart';
import 'package:learn_with_usama/services/database.dart';
import 'package:provider/provider.dart';
import 'models/Courses.dart';
import 'models/Section.dart';
import 'models/Unit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyC113nrM0VS4kN_wpKlG5oiF5RrjLKhHUo',
      appId: '1:451011012873:android:fb7b5b5e361460935fcbd8',
      messagingSenderId: '451011012873',
      projectId: 'leanwithusama',
      storageBucket: 'leanwithusama.appspot.com',
    ),
  );

  runApp(learnWithUsama());
}

class learnWithUsama extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Unit>>.value(
          value: Database().units,
          initialData: [],
        ),
        StreamProvider<List<Courses>>.value(
          value: Database().Course,
          initialData: [],
        ),
        StreamProvider<List<Section>>.value(
          value: Database().section,
          initialData: [],
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        color: Colors.white,
        initialRoute: '/',
        routes: {
          '/': (context) => Root(),
          '/login/': (context) => LoginScreen(),
          '/registration': (context) => RegisterScreen(),
          '/theoryScreen': (context) {
            final unitList = Provider.of<List<Unit>>(context);
            return Theoryscreen(unit: unitList);
          },
          '/home': (context) => Home(),
          '/courseScreen': (context) {
            final courseList = Provider.of<List<Courses>>(context);
            final sectionList = Provider.of<List<Section>>(context);
            return CourseScreen(course: courseList,section: sectionList, unit: selectedUnit,);
          },
          // Make sure to add the Home route
        },
      ),
    );
  }
}