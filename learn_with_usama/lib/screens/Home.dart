import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learn_with_usama/widget/NavDrawer.dart';
import '../widget/AppBar.dart';

class Home extends StatefulWidget {
  static const String id = 'Home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Please Login')),
        body: Center(child: SpinKitHourGlass(color: Colors.black)),
      );
    }
    return Scaffold(
      drawer: NavDrawer(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            AppBar1(page: ''),
            Image(image: AssetImage('images/big_usama.png')),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'My Courses',
                style: GoogleFonts.lato(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            _buildCourseButton(
              context,
              title: 'Theory Explanation',
              subtitle: 'A/L Combined Mathematics lessons',
              imagePath: 'images/landscap01.jpg',
              onPressed: () {
                Navigator.pushNamed(context, '/theoryScreen');
              },
            ),
            _buildCourseButton(
              context,
              title: 'Paper Class Explanations',
              subtitle: 'Past Paper & Model Paper Discussions',
              imagePath: 'images/Exam.jpg',
              onPressed: () {
               Navigator.pushNamed(context, '/paperScreen');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseButton(BuildContext context,
      {required String title,
        required String subtitle,
        required String imagePath,
        required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          ),
          overlayColor: MaterialStateProperty.all(Colors.grey[200]),
          elevation: MaterialStateProperty.all(5.0),
        ),
        onPressed: onPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(
                imagePath,
                height: 250.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              title,
              style: GoogleFonts.lato(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.lato(
                fontSize: 16.0,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
