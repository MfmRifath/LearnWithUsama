import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/Paper.dart';
import '../../models/PaperCourse.dart';
import '../../models/PaperSection.dart';

import '../../widget/AppBar.dart';
import '../../widget/PaperCourseList.dart';
import '../../widget/PaperSectionList.dart';

class PaperCourseScreen extends StatefulWidget {
  final List<PaperSection> section;
  final List<PaperCourses> course;
  final Paper paper;

  const PaperCourseScreen({
    Key? key,
    required this.section,
    required this.course,
    required this.paper,
  }) : super(key: key);

  @override
  State<PaperCourseScreen> createState() => _PaperCourseScreenState();
}

class _PaperCourseScreenState extends State<PaperCourseScreen> with TickerProviderStateMixin {
  late YoutubePlayerController _controller;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late TabController _tabController;
  String? _selectedItem;
  bool _isMenuOpen = false;
  String url = '';
  String? _selectedCourseId;
  bool isLesson = false;
  bool _isLoading = true; // Loading indicator flag
  late FirebaseFirestore _firestore;

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: _isLoading
              ? Center(
            child: SpinKitCubeGrid(
              color: Color(0xffF37979),
            ),
          ) // Show loading indicator
              : YoutubePlayerBuilder(
            player: YoutubePlayer(controller: _controller),
            builder: (context, player) {
              return Column(
                children: [
                  AppBar1(page: '/paperScreen'),
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
                    '${widget.paper.paperName!} ${widget.paper.year}',
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
                'RS: ${widget.paper.payment}/-',
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
                  widget.paper.overviewDescription!,
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
                    backgroundColor:
                    MaterialStatePropertyAll(Color(0xffF37979)),
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
    // Debugging: Print the course data
    print('Total courses: ${widget.course.length}');
    print('Paper ID: ${widget.paper.paperId}');

    final filteredCourses = widget.course.where((course) =>
    course.paperId == widget.paper.paperId).toList();

    // Debugging: Print the filtered course data
    print('Filtered courses count: ${filteredCourses.length}');
    filteredCourses.forEach((course) {
      print('Course ID: ${course.courseId}, Course Name: ${course.courseName}');
    });

    if (filteredCourses.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No courses available for this paper.',
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
                  showAddPaperCourseDialog(context);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xffF37979),
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
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
                section.paperId == course.paperId)
                .toList();

            return AnimatedSize(
              duration: Duration(milliseconds: 300),
              child: Column(
                children: [
                  PaperCourseList(
                    course: course,
                    toggle: () {
                      setState(() {
                        _selectedCourseId = course.courseId;
                        _toggleMenu();
                      });
                    },
                  ),
                  if (_selectedCourseId == course.courseId)
                    PaperSectionList(
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
                      firestore: _firestore,
                    ),
                ],
              ),
            );
          },
        ),
      );
    }
  }

  void showAddPaperCourseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Course'),
          content: TextField(
            decoration: InputDecoration(hintText: 'Enter course details'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                // Add course to Firestore
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showBackDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exit'),
          content: Text('Do you want to exit the screen?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Exit'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
