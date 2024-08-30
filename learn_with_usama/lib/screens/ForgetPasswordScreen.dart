import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? _message;

  void _resetPassword() async {
    final email = _emailController.text;

    if (email.isEmpty || !_validateEmail(email)) {
      setState(() {
        _message = "Please enter a valid email address.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      await _auth.sendPasswordResetEmail(email: email);
      setState(() {
        _message = "Password reset email sent! Please check your inbox.";
      });
    } catch (e) {
      setState(() {
        _message = _handleError(e);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$");
    return emailRegex.hasMatch(email);
  }

  String _handleError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case "user-not-found":
          return "No user found with this email.";
        case "invalid-email":
          return "Invalid email address.";
        case "network-request-failed":
          return "Network error. Please try again later.";
        default:
          return "An unexpected error occurred. Please try again.";
      }
    }
    return "Error: ${error.toString()}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Enter your email address to receive a password reset link.",
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email Address",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: SpinKitCubeGrid(color: Theme.of(context).primaryColor))
                : ElevatedButton(
              onPressed: _resetPassword,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15.0),
              ),
              child: Text("Send Password Reset Email"),
            ),
            if (_message != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  _message!,
                  style: TextStyle(
                    color: _message!.startsWith("Error") ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
