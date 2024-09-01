import 'dart:convert';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learn_with_usama/root.dart';
import 'package:learn_with_usama/screens/AddAdminScreen.dart';
import 'package:learn_with_usama/screens/FeedBackScreen.dart';
import 'package:learn_with_usama/screens/ForgetPasswordScreen.dart';
import 'package:learn_with_usama/screens/Home.dart';
import 'package:learn_with_usama/screens/LoginScreen.dart';
import 'package:learn_with_usama/screens/NotificationListScreen.dart';
import 'package:learn_with_usama/screens/NotificationScreen.dart';
import 'package:learn_with_usama/screens/PaperScreens/PaperCourseScreen.dart';
import 'package:learn_with_usama/screens/PaperScreens/PaperScreen.dart';
import 'package:learn_with_usama/screens/PaperScreens/PaperWidget.dart';
import 'package:learn_with_usama/screens/PrivacyScreen.dart';
import 'package:learn_with_usama/screens/ProfileScreen.dart';
import 'package:learn_with_usama/screens/RegisterScreen.dart';
import 'package:learn_with_usama/screens/SecurityScreen.dart';
import 'package:learn_with_usama/screens/SettingScreen.dart';
import 'package:learn_with_usama/screens/TheoryExplanationPages/CourseScreen.dart';
import 'package:learn_with_usama/screens/TheoryExplanationPages/TheoryScreen.dart';
import 'package:learn_with_usama/screens/TheoryExplanationPages/UnitsWidget.dart';
import 'package:learn_with_usama/screens/editUserDetailScreen.dart';
import 'package:learn_with_usama/screens/UserDetailScreen.dart';
import 'package:learn_with_usama/services/FeedbackProvider.dart';
import 'package:learn_with_usama/services/NotificationProvider.dart';
import 'package:learn_with_usama/services/UserProvider.dart';
import 'package:learn_with_usama/services/database.dart';
import 'models/Courses.dart';
import 'models/Paper.dart';
import 'models/PaperCourse.dart';
import 'models/PaperSection.dart';
import 'models/Section.dart';
import 'models/Unit.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


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
AwesomeNotifications().initialize(null,
    [NotificationChannel(channelKey: '7135', channelName: 'LearnWithUsama', channelDescription: 'Learn')],
debug: true);
  runApp(learnWithUsama());
}


class learnWithUsama extends StatefulWidget {
  @override
  State<learnWithUsama> createState() => _learnWithUsamaState();
}

class _learnWithUsamaState extends State<learnWithUsama> {
@override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed){
      if(!isAllowed){
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Unit>>.value(
          value: Database().units,
          initialData: [],
        ),
        StreamProvider<List<Courses>>.value(
          value: Database().courses,
          initialData: [],
        ),
        StreamProvider<List<Section>>.value(
          value: Database().sections,
          initialData: [],
        ),
        StreamProvider<List<Paper>>.value(
          value: Database().paper,
          initialData: [],
        ),
        StreamProvider<List<PaperCourses>>.value(
          value: Database().paperCourses,
          initialData: [],
        ),
        StreamProvider<List<PaperSection>>.value(
          value: Database().paperSections,
          initialData: [],
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider()..initializeUser(),
        ),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => FeedbackProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        color: Colors.white,
        initialRoute: '/',
        routes: {
          '/': (context) => Root(),
          '/login/': (context) => LoginScreen(),
          '/registration': (context) => RegistrationScreen(),
          '/theoryScreen': (context) {
            final unitList = Provider.of<List<Unit>>(context);
            return Theoryscreen(unit: unitList);
          },
          '/home': (context) => Home(),
          '/courseScreen': (context) {
            final courseList = Provider.of<List<Courses>>(context);
            final sectionList = Provider.of<List<Section>>(context);
            return CourseScreen(course: courseList, section: sectionList, unit: selectedUnit);
          },
          '/profile': (context) => ProfileScreen(),
          '/addUserDetail': (context) => EditUserDetailsPage(),
          '/setting': (context) => SettingsPage(),
          '/forgotPassword': (context) => ForgotPasswordScreen(),
          '/security': (context) => SecurityScreen(),
          '/privacy': (context) => PrivacyPage(),
          '/notifications':(context) =>NotificationScreen(),
          '/notificationSetting': (context) => NotificationPage(),
          '/addAdmin': (context) => AddAdminScreen(),
          '/userDetail': (context) => UsersScreen(),
          '/paperScreen': (context) {
            final paperList = Provider.of<List<Paper>>(context);
            return PaperScreen(paper: paperList);
          },
          '/paperCourseScreen': (context) {
            final paperCourseList = Provider.of<List<PaperCourses>>(context);
            final paperSectionList = Provider.of<List<PaperSection>>(context);
            return PaperCourseScreen( section: paperSectionList, course: paperCourseList, paper: selectedPaper,);
          },
          '/feedback':(context) => FeedbackScreen(),
           },
      ),
    );
  }
}
