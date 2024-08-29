import 'dart:core';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/Section.dart';
import '../models/Courses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Unit.dart';
import '../widget/CourseLIst.dart';
import '../widget/SectionList.dart';
import '../widget/AppBar.dart';

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
  String url = '';
  String? _selectedCourseId;
  bool isLesson = false;

  @override
  void initState() {
    super.initState();
    _initializeYoutubePlayer();
    _initializeAnimationController();
  }

  void _initializeYoutubePlayer() {
    _controller = YoutubePlayerController(
      initialVideoId: '',
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

  void _onSectionTap(String sectionName, String sectionUrl) {
    setState(() {
      _selectedItem = sectionName;
      url = sectionUrl;
      String? videoId = YoutubePlayer.convertUrlToId(url);
      if (videoId != null) {
        _controller.load(videoId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
                        onPressed: () => setState(() => isLesson = false),
                        child: Text('Overview'),
                      ),
                      TextButton(
                        onPressed: () => setState(() => isLesson = true),
                        child: Text('Lessons'),
                      ),
                    ],
                  ),
                ),
                if (!isLesson)
                  _buildOverview(screenWidth)
                else
                  _buildLessonList(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOverview(double screenWidth) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    widget.unit.unitName!,
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
                  widget.unit.overviewDescription!,
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
                    backgroundColor: MaterialStatePropertyAll(Color(0xffF37979)),
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
    );
  }

  Widget _buildLessonList() {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        children: widget.course
            .where((course) => course.unitId == widget.unit.unitNumber)
            .map((course) {
          final courseSections = widget.section
              .where((section) => section.courseId == course.courseId)
              .toList();

          return Column(
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
                SectionList(
                  animation: _animation,
                  items: courseSections,
                  selectedItem: _selectedItem,
                  onSectionTap: (sectionName) {
                    _onSectionTap(
                      sectionName!,
                      courseSections.firstWhere((section) =>
                      section.sectionName == sectionName).sectionUrl ?? '',
                    );
                  }, firestore: FirebaseFirestore.instance,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
