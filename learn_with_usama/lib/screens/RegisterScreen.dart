import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/UserProvider.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'RegistrationScreen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _userProvider = UserProvider();
  String email = '';
  String password = '';
  String displayName = '';
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
      body: GestureDetector(
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
                  image: AssetImage('images/Background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Color Overlay (Optional)
            Container(
              height: screenHeight,
              width: screenWidth,
              color: Colors.black.withOpacity(0.3), // Adjust the opacity as needed
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
                      'Register',
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight * 0.045,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    // Display Name TextField
                    TextField(
                      onChanged: (value) {
                        displayName = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Display Name',
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
                    SizedBox(height: screenHeight * 0.03),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black, backgroundColor: Colors.white, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () async {
                          if (email.isNotEmpty && password.isNotEmpty && displayName.isNotEmpty) {
                            setState(() {
                              showSpinner = true;
                            });
                            FocusScope.of(context).unfocus(); // Dismiss the keyboard before navigating
                            try {
                              final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );

                              await userCredential.user?.updateProfile(displayName: displayName);

                              // Add user to provider with role 'User'
                              await _userProvider.addUser(
                                userCredential.user!.uid,
                                displayName,
                                email,
                                'null', // Default profile picture URL
                                'User',
                                true,
                                true,
                                true// User role
                              );

                              Navigator.pushNamed(context, '/home'); // Navigate to Home screen
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                showErrorDialog('The password provided is too weak.');
                              } else if (e.code == 'email-already-in-use') {
                                showErrorDialog('The account already exists for that email.');
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
                            showErrorDialog('Please fill in all fields.');
                          }
                        },
                        child: Text(
                          'Register',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: screenHeight * 0.022,
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
                            'Already have an account?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenHeight * 0.018,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/login',
                              );
                            },
                            child: Text(
                              'Login',
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
            if (showSpinner)
              Center(
                child: SpinKitDualRing(color: Colors.white,)
              ),
          ],
        ),
      ),
    );
  }
}
