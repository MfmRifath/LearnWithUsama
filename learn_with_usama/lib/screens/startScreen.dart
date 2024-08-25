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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss the keyboard when tapping outside
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height, // Ensure the container fills the screen height
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/Background.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 125.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 150.0,
                          width: 150.0,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/Usama.png'),
                            ),
                          ),
                        ),
                        Text(
                          'LearnWithUsama',
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              fontSize: 25.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          'Combined',
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.black26,
                            ),
                          ),
                        ),
                        Text(
                          'Mathematics',
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.black26,
                            ),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        Row(
                          children: <Widget>[
                            Container(
                              height: 75.0,
                              width: 75.0,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('images/s2oLogo.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            Container(
                              height: 75.0,
                              width: 75.0,
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
                    padding: const EdgeInsets.only(right: 25.0),
                    child: Align(
                      alignment: Alignment.centerRight,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text(
                          'Get Started',
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
