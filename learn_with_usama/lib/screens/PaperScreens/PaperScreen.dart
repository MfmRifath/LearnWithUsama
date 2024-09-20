import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learn_with_usama/models/Courses.dart';
import 'package:learn_with_usama/models/Section.dart';
import 'package:learn_with_usama/widget/AppBar.dart';
import 'package:learn_with_usama/widget/NavDrawer.dart';

import '../../models/Paper.dart';
import 'PaperWidget.dart';

class PaperScreen extends StatefulWidget {
  late List<Paper> paper;

  PaperScreen({required this.paper});

  @override
  State<PaperScreen> createState() => _PaperScreenState();
}

class _PaperScreenState extends State<PaperScreen> {
  late final FirebaseFirestore firestore_;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    firestore_ = FirebaseFirestore.instance;
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        String role = userDoc['role'];
        setState(() {
          _isAdmin = role == 'Admin';
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user role: $e');
      }
    }
  }

  Future<int> getPaperCount() async {
    final querySnapshot = await firestore_.collection('papers').get();
    return querySnapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Feedback')),
        body: Center(child: SpinKitHourGlass(color: Colors.black)),
      );
    }
    return Scaffold(
      drawer: NavDrawer(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            AppBar1(page: '/home'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Paper Class Explanation',
                    style: GoogleFonts.nunito(
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: getPaperCount(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red),
                            SizedBox(width: 4.0),
                            Text('Error loading Paper Class Count'),
                          ],
                        );
                      } else if (snapshot.hasData) {
                        return Text(
                          '${snapshot.data} Available Papers',
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else {
                        return Text('No Paper classes are available');
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: widget.paper.isEmpty
                  ? Center(
                child: Text(
                  'No Paper class are available',
                  style: GoogleFonts.nunito(
                    textStyle: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 20.0),
                itemCount: widget.paper.length,
                itemBuilder: (context, index) => Papers(
                  paper: widget.paper[index],
                ),
              ),
            ),
            if (_isAdmin)
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FloatingActionButton.extended(
                    backgroundColor: Colors.pinkAccent,
                    icon: Icon(Icons.add),
                    label: Text("Add paper"),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddPaperDialog();
                        },
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
