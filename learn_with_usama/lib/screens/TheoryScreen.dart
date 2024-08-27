import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learn_with_usama/models/Courses.dart';
import 'package:learn_with_usama/models/Section.dart';
import 'package:learn_with_usama/services/UnitServises.dart';
import 'package:learn_with_usama/widget/AppBar.dart';
import 'package:learn_with_usama/widget/NavDrawer.dart';

import '../models/Unit.dart';

import 'UnitsWidget.dart';
class Theoryscreen extends StatefulWidget {
  late List <Unit> unit;

   Theoryscreen({required this.unit});

  @override
  State<Theoryscreen> createState() => _TheoryscreenState();
}

class _TheoryscreenState extends State<Theoryscreen> {
  late final FirebaseFirestore firestore_;



  @override
  void initState() {
    super.initState();
    firestore_ = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    Future<int> getUnitCount() async {
      final querySnapshot = await firestore_.collection('units').get();
      return querySnapshot.docs.length;
    }
    return Scaffold(
      drawer: NavDrawer(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            AppBar1(page: '',),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Theory Explanation',
                    style: GoogleFonts.nunito(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: FutureBuilder(future: getUnitCount(), builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return Text(
                          '${snapshot.data} Available Units',
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else {
                        return Text('No units available');
                      }
                    },),
                  )

                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                      itemCount: widget.unit.length,
                      itemBuilder: (context, index) => Units(unit: widget.unit[index]),
                    )


              ),

            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: IconButton(
                    hoverColor: Color(0xffFFD7D7),
                    icon: Icon(Icons.add),
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
            ),
          ],
        ),
      ),
    );
  }
}
