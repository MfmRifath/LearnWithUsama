import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/User.dart';
import '../services/FeedbackProvider.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  AppUser? _currentUser;
  bool _isSubmitting = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    AppUser? user = await getCurrentUser();
    setState(() {
      _currentUser = user;
    });
  }

  Future<AppUser?> getCurrentUser() async {
    final User? firebaseUser = _auth.currentUser;

    if (firebaseUser == null) {
      return null;
    }

    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();

      if (!userDoc.exists) {
        return AppUser.fromFirebaseUser(
          uid: firebaseUser.uid,
          email: firebaseUser.email,
          displayName: firebaseUser.displayName,
          profilePictureUrl: firebaseUser.photoURL,
          role: 'User',
        );
      }

      return AppUser.fromDocument(userDoc);
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    setState(() {
      _isSubmitting = true;
    });

    final message = _messageController.text;
    if (message.isNotEmpty && _currentUser != null) {
      try {
        await Provider.of<FeedbackProvider>(context, listen: false).addFeedback(
          message,
          _currentUser!.displayName!,
          _currentUser!.profilePictureUrl!,
        );
        _messageController.clear();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Icon(Icons.thumb_up, color: Colors.green, size: 48),
              content: Text(
                'Thank you for your feedback!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        print('Error submitting feedback: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit feedback')));
      }
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  Future<void> _deleteFeedback(String feedbackId) async {
    setState(() {
      _isDeleting = true;
    });

    try {
      await Provider.of<FeedbackProvider>(context, listen: false).deleteFeedback(feedbackId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Feedback deleted')));
    } catch (e) {
      print('Error deleting feedback: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete feedback')));
    }

    setState(() {
      _isDeleting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Feedback')),
        body: Center(child: SpinKitHourGlass(color: Colors.black)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(_currentUser!.profilePictureUrl! ?? ''),
                      radius: 28.0,
                    ),
                    SizedBox(width: 16),
                    Text(
                      _currentUser!.displayName ?? 'User',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    labelText: 'Share your feedback',
                    hintText: 'Enter your feedback...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomRight,
                  child: _isSubmitting
                      ? SpinKitDoubleBounce(color: Colors.purple,)
                      : FloatingActionButton.extended(
                    onPressed: _submitFeedback,
                    icon: Icon(Icons.send),
                    label: Text('Submit Feedback'),
                    backgroundColor: Theme.of(context).primaryColor,
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Consumer<FeedbackProvider>(
                  builder: (context, feedbackProvider, child) {
                    if (feedbackProvider.feedbacks.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.feedback_outlined, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No feedback yet.',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Be the first to submit your feedback!',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: feedbackProvider.feedbacks.length,
                      itemBuilder: (context, index) {
                        final feedback = feedbackProvider.feedbacks[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(feedback.profileImageUrl),
                                  radius: 28,
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        feedback.name,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        feedback.message,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        DateFormat.yMMMd().add_jm().format(feedback.createdAt.toDate()),
                                        style: TextStyle(color: Colors.grey, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_currentUser != null && _currentUser!.role == 'Admin')
                                  IconButton(
                                    icon: _isDeleting
                                        ? SpinKitCircle(color: Colors.red, size: 24)
                                        : Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _deleteFeedback(feedback.id);
                                    },
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
