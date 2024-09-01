import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learn_with_usama/models/Courses.dart';
import 'package:learn_with_usama/models/Section.dart';
import 'package:learn_with_usama/widget/AppBar.dart';
import 'package:learn_with_usama/widget/NavDrawer.dart';

import '../../models/Unit.dart';
import 'UnitsWidget.dart';

class Theoryscreen extends StatefulWidget {

  late List<Unit> unit;

  Theoryscreen({required this.unit});

  @override
  State<Theoryscreen> createState() => _TheoryscreenState();
}

class _TheoryscreenState extends State<Theoryscreen> {
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

  Future<int> getUnitCount() async {
    final querySnapshot = await firestore_.collection('units').get();
    return querySnapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
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
                    'Theory Explanation',
                    style: GoogleFonts.nunito(
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: getUnitCount(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red),
                            SizedBox(width: 4.0),
                            Text('Error loading units'),
                          ],
                        );
                      } else if (snapshot.hasData) {
                        return Text(
                          '${snapshot.data} Available Units',
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else {
                        return Text('No units available');
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: widget.unit.isEmpty
                  ? Center(
                child: Text(
                  'No units available',
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
                itemCount: widget.unit.length,
                itemBuilder: (context, index) => Units(
                  unit: widget.unit[index],
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
                    label: Text("Add Unit"),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddUnitDialog();
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
