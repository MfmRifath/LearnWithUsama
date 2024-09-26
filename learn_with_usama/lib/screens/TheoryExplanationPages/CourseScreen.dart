import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learn_with_usama/services/Course&SectionSevices.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/Courses.dart';
import '../../models/Section.dart';
import '../../models/Unit.dart';
import '../../models/User.dart';
import '../../widget/AppBar.dart';
import '../../widget/CourseLIst.dart';
import '../../widget/SectionList.dart';
import '../payHereFormUnit.dart';


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

class _CourseScreenState extends State<CourseScreen> with TickerProviderStateMixin {
  late YoutubePlayerController _controller;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late TabController _tabController;
  String? _selectedItem;
  bool _isMenuOpen = false;
  String url = '';
  String? _selectedCourseId;
  bool isLesson = false;
  bool _isLoading = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _initializeYoutubePlayer();
    _initializeAnimationController();
    _tabController = TabController(length: 2, vsync: this);
    // Simulate a network call or heavy processing
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false; // Stop loading after delay
      });
    });
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
    _tabController.dispose();
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

  Future<bool> _onWillPop() async {
    if (_animationController.isAnimating) {
      _controller.pause();
      _animationController.reverse();
      return false;
    }

    final shouldPop = await _showBackDialog(context);
    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    if (FirebaseAuth.instance.currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Please Login')),
        body: Center(child: SpinKitHourGlass(color: Colors.black)),
      );
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: _isLoading
              ? Center(child: SpinKitCubeGrid(
              color: Color(0xffF37979)
          )) // Show loading indicator
              : YoutubePlayerBuilder(
            player: YoutubePlayer(controller: _controller),
            builder: (context, player) {
              return Column(
                children: [
                  AppBar1(page: '/theoryScreen',push: () =>_controller.pause(),),
                  player,
                  SizedBox(height: 15.0),
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Color(0xFFF37979),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: "OverView"),
                      Tab(text: "Lessons"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildOverview(screenWidth),
                        _buildLessonList(),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
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
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentFormPageUnit(fixedAmount: widget.unit.payment!, unitId: widget.unit.documentId!,)));
                  },
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
    );
  }

  Widget _buildLessonList() {
    final filteredCourses = widget.course.where((course) =>
    course.unitId == widget.unit.unitNumber).toList();

    if (filteredCourses.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No courses available for this unit.',
                style: GoogleFonts.nunito(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextButton(
                onPressed: () {
                  showAddCourseDialog(context);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xffF37979),
                  padding: EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 20.0),
                ),
                child: Text(
                  'Add Course',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          itemCount: filteredCourses.length,
          itemBuilder: (context, index) {
            final course = filteredCourses[index];
            final courseSections = widget.section
                .where((section) =>
            section.courseId == course.courseId &&
                section.unitId == course.unitId)
                .toList();

            return AnimatedSize(
              duration: Duration(milliseconds: 300),
              child: Column(
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
                          courseSections
                              .firstWhere((section) =>
                          section.sectionName == sectionName)
                              .sectionUrl ?? '',
                        );
                      },
                      firestore: FirebaseFirestore.instance, amount: widget.unit.payment!,
                    ),
                ],
              ),
            );
          },
        ),
      );
    }
  }

  Future<bool?> _showBackDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _controller.pause();
                Navigator.pushNamed(context, '/theoryScreen');
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

}
