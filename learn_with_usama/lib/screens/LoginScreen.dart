import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learn_with_usama/screens/Home.dart';
import 'package:learn_with_usama/services/login.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'LoginScreen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool showSpinner = false;

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Stack(
              children: [
                // Background Image
                Container(
                  height: screenHeight,
                  width: screenWidth,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/BackgroundLogin.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Color Overlay (Optional)
                Container(
                  height: screenHeight,
                  width: screenWidth,
                  color: Colors.black.withOpacity(0.1),
                ),
                // Content inside SingleChildScrollView
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: screenHeight * 0.35),
                        Text(
                          'Login',
                          style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenHeight * 0.045,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        // Email TextField
                        TextField(
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: screenHeight * 0.02,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 4.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenHeight * 0.02,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        // Password TextField
                        TextField(
                          onChanged: (value) {
                            password = value;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: screenHeight * 0.02,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 4.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenHeight * 0.02,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/forgotPassword');
                            },
                            child: Text(
                              'Forgot Password?',
                              style: GoogleFonts.nunito(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenHeight * 0.018,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.015),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                if (email.isNotEmpty && password.isNotEmpty) {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  FocusScope.of(context).unfocus();
                                  try {
                                    await loginUser(email, password, context, Home());
                                     } on FirebaseAuthException catch (e) {
                                    if (e.code == 'user-not-found') {
                                      showErrorDialog('No user found for that email.');
                                    } else if (e.code == 'wrong-password') {
                                      showErrorDialog('Wrong password provided.');
                                    } else if (e.code == 'invalid-email') {
                                      showErrorDialog('Invalid email provided.');
                                    } else {
                                      showErrorDialog('An error occurred: ${e.message}');
                                    }
                                  } catch (e) {
                                    showErrorDialog('An unexpected error occurred: ${e.toString()}');
                                    print('Unexpected error: $e');
                                  } finally {
                                    setState(() {
                                      showSpinner = false;
                                    });
                                  }
                                } else {
                                  showErrorDialog('Please fill in both email and password fields.');
                                }
                              },
                              child: Text(
                                'Login',
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
                        SizedBox(height: screenHeight * 0.05),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text(
                                'Don\'t have an account?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenHeight * 0.018,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/registration');
                                },
                                child: Text(
                                  'Register',
                                  style: GoogleFonts.nunito(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenHeight * 0.018,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Circular Loader
          if (showSpinner)
            Center(
              child: SpinKitDoubleBounce(
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
