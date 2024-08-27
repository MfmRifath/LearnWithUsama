import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learn_with_usama/screens/LoginScreen.dart';

class StartScreen extends StatefulWidget {
  static const String id = 'StartScreen';
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Dismiss the keyboard when tapping outside
          },
          child: SingleChildScrollView(
            child: Container(
              height: screenHeight, // Ensure the container fills the screen height
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/Background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: screenHeight * 0.15),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: screenHeight * 0.2,
                          width: screenHeight * 0.2,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/Usama.png'),
                            ),
                          ),
                        ),
                        Text(
                          'LearnWithUsama',
                          style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              fontSize: screenHeight * 0.03,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          'Combined',
                          style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                              fontSize: screenHeight * 0.025,
                              color: Colors.black26,
                            ),
                          ),
                        ),
                        Text(
                          'Mathematics',
                          style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                              fontSize: screenHeight * 0.025,
                              color: Colors.black26,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Row(
                          children: <Widget>[
                            Container(
                              height: screenHeight * 0.1,
                              width: screenHeight * 0.1,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('images/s2oLogo.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.05),
                            Container(
                              height: screenHeight * 0.1,
                              width: screenHeight * 0.1,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('images/s2oLogo.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.07),
                    child: Align(
                      alignment: Alignment.centerRight,
                      
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 50.0),
                        child: TextButton(
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(
                              const BorderSide(
                                color: Colors.white,
                                width: 3.0,
                              ),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));

                          },
                          child: Text(
                            'Get Started',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: screenHeight * 0.022,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
