import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learn_with_usama/screens/Home.dart';
import 'package:learn_with_usama/screens/RegisterScreen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
      resizeToAvoidBottomInset: true, // Automatically adjusts for keyboard
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Dismiss the keyboard when tapping outside
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
                color: Colors.black.withOpacity(0.1), // Adjust the opacity as needed
              ),
              // Content inside SingleChildScrollView to prevent overflow
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
                          color: Colors.white, // Text color in TextField
                          fontSize: screenHeight * 0.02,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      // Password TextField
                      TextField(
                        onChanged: (value) {
                          password = value;
                        },
                        obscureText: true, // Hide password input
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
                          color: Colors.white, // Text color in TextField
                          fontSize: screenHeight * 0.02,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forget Password?',
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
                                  color: Colors.white, // Border color
                                  width: 3, // Border width
                                ),
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8), // Rounded corners
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (email.isNotEmpty && password.isNotEmpty) {
                                setState(() {
                                  showSpinner = true;
                                });
                                FocusScope.of(context).unfocus(); // Dismiss the keyboard before navigating
                                try {
                                  await _auth.signInWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Home()));                                } on FirebaseAuthException catch (e) {
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
                                  print('Unexpected error: $e'); // Log the error details
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
                                Navigator.pushNamed(
                                  context,
                                  '/registration',
                                );
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
      ),
    );
  }
}
