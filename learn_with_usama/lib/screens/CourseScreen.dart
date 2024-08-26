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
  final Section? section;
  final Courses? course;
  final Unit? unit;

  const CourseScreen({
    Key? key,
    this.section,
    this.course, this.unit,
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
  late String url;
  String? _selectedCourseId;
  List<Section> _sections = [];
  List<Courses> _courses = [];
  Map<String, List<Section>> _sectionsByCourseId = {};
  bool isLesson = false;
  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;

    // Initialize YouTube player with the section's URL if available
    url = widget.section?.sectionUrl ?? '';
    String? videoId = YoutubePlayer.convertUrlToId(url);

    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    // Initialize the animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Fetch all courses and sections
    _fetchCourses();
    _fetchSections();
  }

  Future<void> _fetchCourses() async {
    try {
      final snapshot = await _firestore.collection('courses').orderBy(
          'courseId').get();
      final courses = snapshot.docs.map((doc) => Courses.fromFirestore(doc))
          .toList();
      setState(() {
        _courses = courses;
      });
    } catch (e) {
      print('Error fetching courses: $e');
    }
  }

  Future<void> _fetchSections() async {
    try {
      final snapshot = await _firestore.collection('section').orderBy(
          'sectionId').get();
      final sections = snapshot.docs.map((doc) => Section.fromFirestore(doc))
          .toList();
      setState(() {
        _sections = sections;
        _sectionsByCourseId = {};
        for (var section in sections) {
          final courseId = section.coursesId;
          if (courseId != null) {
            if (_sectionsByCourseId.containsKey(courseId)) {
              _sectionsByCourseId[courseId]!.add(section);
            } else {
              _sectionsByCourseId[courseId] = [section];
            }
          }
        }
      });
    } catch (e) {
      print('Error fetching sections: $e');
    }
  }

  Future<void> _addCourse() async {
    final courseNameController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Course'),
          content: TextField(
            controller: courseNameController,
            decoration: InputDecoration(labelText: 'Course Name'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final courseName = courseNameController.text;
                if (courseName.isNotEmpty) {
                  await _firestore.collection('courses').add({
                    'courseName': courseName,
                    'courseId': DateTime
                        .now()
                        .millisecondsSinceEpoch
                        .toString(),
                  });
                  _fetchCourses();
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addSection(String courseId) async {
    final sectionNameController = TextEditingController();
    final sectionUrlController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Section'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: sectionNameController,
                decoration: InputDecoration(labelText: 'Section Name'),
              ),
              TextField(
                controller: sectionUrlController,
                decoration: InputDecoration(labelText: 'Section URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final sectionName = sectionNameController.text;
                final sectionUrl = sectionUrlController.text;
                if (sectionName.isNotEmpty && sectionUrl.isNotEmpty) {
                  await _firestore.collection('section').add({
                    'sectionName': sectionName,
                    'sectionUrl': sectionUrl,
                    'coursesId': courseId,
                    'sectionId': DateTime
                        .now()
                        .millisecondsSinceEpoch
                        .toString(),
                  });
                  _fetchSections();
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editCourse(String courseId, String currentName) async {
    final courseNameController = TextEditingController(text: currentName);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Course'),
          content: TextField(
            controller: courseNameController,
            decoration: InputDecoration(labelText: 'Course Name'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final courseName = courseNameController.text;
                if (courseName.isNotEmpty) {
                  await _firestore.collection('courses').doc(courseId).update({
                    'courseName': courseName,
                  });
                  _fetchCourses();
                }
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editSection(String sectionId, String currentName,
      String currentUrl) async {
    final sectionNameController = TextEditingController(text: currentName);
    final sectionUrlController = TextEditingController(text: currentUrl);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Section'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: sectionNameController,
                decoration: InputDecoration(labelText: 'Section Name'),
              ),
              TextField(
                controller: sectionUrlController,
                decoration: InputDecoration(labelText: 'Section URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final sectionName = sectionNameController.text;
                final sectionUrl = sectionUrlController.text;
                if (sectionName.isNotEmpty && sectionUrl.isNotEmpty) {
                  await _firestore.collection('section').doc(sectionId).update({
                    'sectionName': sectionName,
                    'sectionUrl': sectionUrl,
                  });
                  _fetchSections();
                }
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCourse(String courseId) async {
    await _firestore.collection('courses').doc(courseId).delete();
    _fetchCourses();
  }

  Future<void> _deleteSection(String sectionId) async {
    await _firestore.collection('section').doc(sectionId).delete();
    _fetchSections();
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Custom AppBar widget
            AppBar1(),
            // YouTube Player widget
            Container(
              width: screenWidth,
              height: screenHeight *0.4,
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.amber,
                progressColors: const ProgressBarColors(
                  playedColor: Colors.amber,
                  handleColor: Colors.amberAccent,
                ),
              ),
            ),
            SizedBox(height: 15.0),
            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                      onPressed: (){
                        setState(() {
                          isLesson = false;
                        });
                      },
                      child:Text('Overview')
                  ),
                  TextButton(
                      onPressed: (){
                        setState(() {
                          isLesson = true;
                        });
                      },
                      child:Text('Lessons')
                  ),
                ],
              ),
            ),
            if(!isLesson)
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0,top: 10.0,bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('${widget.unit!.unitName}',
                                style: GoogleFonts.nunito(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0
                                    )
                                ),
                              ),
                              Text('By MSM.Usama',
                                style: GoogleFonts.nunito(
                                    textStyle: TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0
                                    )
                                ),)
                            ],),
                          Text('RS: ${widget.unit!.payment}/-',
                            style: GoogleFonts.nunito(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth*0.045
                                )
                            ),)
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.0,right: 15.0),
                      child: Text('${widget.unit!.overviewDescripton}',style: GoogleFonts.nunito(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0
                          )
                      ),),
                    ),
                    SizedBox(height: 10.0,),
                    Padding(
                      padding: EdgeInsets.only(left: 30.0,right: 30.0,bottom: 50.0),
                      child: TextButton(
                        onPressed: (){},
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Color(0xffF37979)),
                        ),
                        child: Text('Get Entroll',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth *0.035
                          ),),
                      ),
                    ),
                  ],
                ),
              ),

            if(isLesson)
            // Course list and Section list without gaps
              Expanded(
                child: _courses.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: _courses.where((course)=>course.unitId == widget.unit!.documentId).length,
                  itemBuilder: (context, index) {
                    final course = _courses.where((course)=>course.unitId == widget.unit!.documentId).toList()[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CourseList(
                          selectedItem: _selectedItem,
                          course: course,
                          toggle: () {
                            setState(() {

                              _selectedCourseId = course.courseId;
                              _toggleMenu();
                            });
                          },
                          onEdit: () =>
                              _editCourse(course.courseId!, course.courseName),
                          onDelete: () => _deleteCourse(course.courseId!),
                          onAddSection: () => _addSection(course.courseId!),
                        ),

                        if (_selectedCourseId == course.courseId)
                          Column(
                            children: _sectionsByCourseId[_selectedCourseId]?.map((
                                section) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SectionList(
                                    animation: _animation,
                                    items: [section],
                                    selectedItem: _selectedItem,
                                    onSectionTap: (sectionName) {
                                      setState(() {
                                        _selectedItem = sectionName;
                                        url = section.sectionUrl ?? '';
                                        _controller.load(
                                            YoutubePlayer.convertUrlToId(url) ?? '');
                                      });
                                    },
                                    onEdit: () => _editSection(section.sectionId!,
                                        section.sectionName ?? '',
                                        section.sectionUrl ?? ''),
                                    onDelete: () =>
                                        _deleteSection(section.sectionId!),
                                  ),
                                  SizedBox(height: 10.0),

                                ],

                              );
                            }).toList() ?? [Center(child: Text(

                                'No sections available'))

                            ],
                          ),
                      ],
                    );
                  },
                ),
              ),
            if(isLesson)
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: IconButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Color(0xffF37979))
                    ),
                    icon: Icon(Icons.add),
                    onPressed: _addCourse,
                  ),
                ),
              ),
          ],
        ),
      ),

    );
  }
}