import 'package:flutter/material.dart';
import 'package:learn_with_usama/widget/AppBar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/Section.dart';
import '../models/Courses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseScreen extends StatefulWidget {
  final Section? section;
  final Courses? course;

  const CourseScreen({
    Key? key,
    this.section,
    this.course,
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addCourse,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
            children: <Widget>[
            // Custom AppBar widget
            AppBar1(),
        // YouTube Player widget
        Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
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
        // Course list and Section list without gaps
        Expanded(
          child: _courses.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: _courses.length,
            itemBuilder: (context, index) {
              final course = _courses[index];
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
       ],
    ),
    ),

    );
  }
}

// CourseList widget
class CourseList extends StatelessWidget {
  final String? selectedItem;
  final Courses course;
  final VoidCallback toggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAddSection;

  const CourseList({
    Key? key,
    required this.selectedItem,
    required this.course,
    required this.toggle,
    required this.onEdit,
    required this.onDelete,
    required this.onAddSection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggle,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.deepPurpleAccent, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              course.courseName,
              style: TextStyle(color: Colors.deepPurple, fontSize: 16.0),
            ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: onDelete,
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: onAddSection,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// SectionList widget
class SectionList extends StatelessWidget {
  final Animation<double> animation;
  final List<Section> items;
  final String? selectedItem;
  final void Function(String?)? onSectionTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SectionList({
    Key? key,
    required this.animation,
    required this.items,
    this.selectedItem,
    this.onSectionTap,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      axisAlignment: -1.0,
      child: Column(
        children: items.map((section) {
          final bool isSelected = selectedItem != null &&
              selectedItem == section.sectionName;

          return ListTile(
            title: Row(
              children: <Widget>[
                Icon(
                  isSelected ? Icons.stop_circle : Icons.play_circle,
                  color: Color(0xffFF8A8A),
                ),
                SizedBox(width: 10.0),
                Text(section.sectionName ?? 'No Name'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ],
            ),
            onTap: () {
              if (onSectionTap != null) {
                onSectionTap!(section.sectionName);
              }
            },
          );
        }).toList(),
      ),
    );
  }
}
