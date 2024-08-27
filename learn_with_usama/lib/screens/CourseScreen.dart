import 'dart:core';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learn_with_usama/widget/AppBar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/Section.dart';
import '../models/Courses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Unit.dart';
import '../widget/CourseLIst.dart';
import '../widget/SectionList.dart';

class CourseScreen extends StatefulWidget {
  final List<Section> section;
  final List<Courses> course;
  final Unit unit;

  const CourseScreen({
    Key? key,
    required this.section,
    required this.course,
    required this.unit,
  }) : super(key: key);

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen>
    with SingleTickerProviderStateMixin {
  late YoutubePlayerController _controller;
  late AnimationController _animationController;
  late Animation<double> _animation;
  String? _selectedItem;
  bool _isMenuOpen = false;
  late FirebaseFirestore _firestore;
  String url = '';
  String? _selectedCourseId;
  List<Section> _sections = [];
  List<Courses> _courses = [];
  Map<String, List<Section>> _sectionsByCourseId = {};
  bool isLesson = false;

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;

    _initializeYoutubePlayer();
    _initializeAnimationController();
  }

  void _initializeYoutubePlayer() {
    String? videoId = YoutubePlayer.convertUrlToId(url);
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  void _initializeAnimationController() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  Future<void> _showErrorDialog(String message) async {
    await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      if (_isMenuOpen) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      body: SafeArea(
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(controller: _controller),
          builder: (BuildContext, player) {
            return Column(
              children: [
                AppBar1(page: '/theoryScreen'),
                player,
                SizedBox(height: 15.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLesson = false;
                          });
                        },
                        child: Text('Overview'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLesson = true;
                          });
                        },
                        child: Text('Lessons'),
                      ),
                    ],
                  ),
                ),
                if (!isLesson)
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Text(
                                  '${widget.unit.unitName}',
                                  style: GoogleFonts.nunito(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'By MSM.Usama',
                                  style: GoogleFonts.nunito(
                                    textStyle: TextStyle(
                                      color: Colors.black26,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              'RS: ${widget.unit.payment}/-',
                              style: GoogleFonts.nunito(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.045,
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                '${widget.unit.overviewDescription}',
                                style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color(0xffF37979)),
                                ),
                                child: Text(
                                  'Get Enroll',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.035,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                if (isLesson)
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      itemCount: widget.course
                          .where((course) =>
                      course.unitId == widget.unit.unitNumber)
                          .length,
                      itemBuilder: (context, courseIndex) {
                        final course = widget.course.where((course) =>
                        course.unitId == widget.unit.unitNumber)
                            .toList()[courseIndex];
                        final courseSections = widget.section.where((section) =>
                        section.courseId == course.courseId)
                            .toList();

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          // Allow the column to shrink-wrap its children
                          children: [
                            CourseList(
                              course: course,
                              toggle: () {
                                setState(() {
                                  _selectedCourseId = course.courseId;
                                  _toggleMenu();
                                });
                              },
                            ),
                            if (_selectedCourseId == course.courseId)
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: courseSections.length,
                                itemBuilder: (context, sectionIndex) {
                                  final section = courseSections[sectionIndex];
                                  return SizeTransition(
                                    sizeFactor: _animation,
                                    axisAlignment: 0.0,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      // Allow the column to shrink-wrap its children
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        SectionList(
                                          animation: _animation,
                                          items: courseSections,
                                          selectedItem: _selectedItem,
                                          onSectionTap: (sectionName) {
                                            setState(() {
                                              _selectedItem = sectionName;
                                              url = section.sectionUrl ?? '';
                                              _controller.load(
                                                  YoutubePlayer.convertUrlToId(
                                                      url) ?? '');
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                          ],
                        );
                      },
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }
}