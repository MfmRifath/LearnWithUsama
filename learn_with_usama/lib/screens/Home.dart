import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.white60,
              child: Row(
                children: <Widget>[
                  TextButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.white)),
                    onPressed: () {},
                    icon: ClipOval(
                      child: Image.asset('images/s2o-academy.png',
                      height: 50.0,
                      width: 50.0,),
                    ),
                    label: Text(
                      'Your Name',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 150.0,),
                  IconButton(
                      color: Colors.pinkAccent,
                      onPressed: (){}
                      , icon: Icon(CupertinoIcons.bell),
                  ),
                ],
              ),
            ),
            Image(image: AssetImage('images/big_usama.png')),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('My Courses',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                    )
                  )
                ),
                onPressed: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max, // To keep the size of the button as small as possible
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
              padding:  EdgeInsets.only(left: 8.0, top: 0.8, bottom: 15.0,right: 8.0),
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)
                        )
                    )
                ),
                onPressed: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max, // To keep the size of the button as small as possible
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
