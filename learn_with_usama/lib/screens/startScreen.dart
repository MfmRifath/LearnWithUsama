import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learn_with_usama/screens/LoginScreen.dart';
class startScreen extends StatefulWidget {
  const startScreen({super.key});

  @override
  State<startScreen> createState() => _startScreenState();
}

class _startScreenState extends State<startScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image:DecorationImage(
              image:AssetImage('images/Background.png',),
              fit: BoxFit.fill
            )
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: 125.0,),
              Row(
                children: <Widget>[
                  SizedBox(width: 25.0,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 150.0,
                        width: 150.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/Usama.png')
                          )
                        ),
                      ),
                      Text('LearnWithUsama',
                        style: GoogleFonts.nunito(
                          textStyle:  TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            fontSize: 25.0,
                          ),
                        )

                      ),
                      Text('Combined',
                        style: GoogleFonts.nunito(
                          textStyle:  TextStyle(
                            fontSize: 20.0,
                            color: Colors.black26
                          ),
                        )
                      ),
                      Text('Mathematics',
                        style: TextStyle(
                          fontSize: 20.0,
                            color: Colors.black26
                        ),

                      ),
                      SizedBox(height: 25.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 75.0,
                            width: 75.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('images/s2oLogo.png',),
                                  fit: BoxFit.fill
                                )
                            ),
                          ),
                          Container(
                            height: 75.0,
                            width: 75.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('images/s2oLogo.png'),
                                  fit: BoxFit.fill
                                )
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 150,),
              Row(
                children: <Widget>[
                  SizedBox(width: 225.0,),
                  TextButton(
                    style: ButtonStyle(

                      // Add border to TextButton
                      side: MaterialStateProperty.all(
                        BorderSide(
                          color: Colors.white,  // Border color
                          width: 3,  // Border width
                        ),
                      ),
                      // Optional: You can also define the shape if you want rounded corners
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),  // Rounded corners
                        ),
                      ),
                    ),
                    onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                      child: Text(
                        'Get Started',
                        style: GoogleFonts.lato(
                          textStyle:  TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
