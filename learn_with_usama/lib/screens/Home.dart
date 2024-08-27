import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learn_with_usama/screens/LoginScreen.dart';
import 'package:learn_with_usama/screens/TheoryScreen.dart';
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
    return Scaffold(
      drawer: NavDrawer(),  // Add your NavDrawer here
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            AppBar1(page: '',),
            Image(image: AssetImage('images/big_usama.png')),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'My Courses',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)))),
                onPressed: () {
                  Navigator.pushNamed(context, '/theoryScreen');

                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  // To keep the size of the button as small as possible
                  children: [
                    Image.asset(
                      'images/landscap01.jpg',
                      height: 250.0,
                      width: 400.0,
                    ),
                    SizedBox(height: 8.0), // Add some space between the image and the text
                    Text(
                      'Theory Explanation',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'A/L Combined Mathematics lessons',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 8.0, top: 0.8, bottom: 15.0, right: 8.0),
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)))),
                onPressed: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  // To keep the size of the button as small as possible
                  children: [
                    Image.asset(
                      'images/landscape02.jpg',
                      height: 250.0,
                      width: 400.0,
                    ),
                    SizedBox(height: 8.0), // Add some space between the image and the text
                    Text(
                      'Paper Class Explanations',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Past Paper & Model Paper Discussions',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

