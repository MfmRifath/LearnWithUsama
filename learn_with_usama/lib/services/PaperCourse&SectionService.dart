
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:learn_with_usama/services/database.dart';
import 'package:provider/provider.dart';
import '../models/Notification.dart';
import '../models/PaperCourse.dart';
import '../models/PaperSection.dart';
import 'NotificationProvider.dart';
import 'dart:math';
import 'UserProvider.dart';

Future<void> createAndStoreNotification(BuildContext context, String title, String body) async {
  // Access the UserProvider to check if notifications are enabled
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final appUser = userProvider.appUser;

  // Check if notifications are enabled
  if (appUser != null && appUser.notificationsEnabled) {
    final notification = MyNotification(
      title: title,
      body: body,
      date: DateTime.now(),
    );

    // Create and display the notification
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Random().nextInt(10000),
        channelKey: '7135',
        title: notification.title,
        body: notification.body,
      ),
    );

    // Store the notification in Firestore via the provider
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    await notificationProvider.addNotification(notification);
  } else {
    print('Notifications are disabled, so the notification was not sent.');
  }
}

Future<void> showAddPaperCourseDialog(BuildContext context) async {
  String courseName = '';
  String courseId = '';
  String paperId = '';
  bool isLoading = false;

  // Function to show a loading dialog
  void _showLoadingDialog() {
    showDialog(
      barrierColor: Colors.white10,
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => AlertDialog(
        content: Row(
          children: <Widget>[
            SpinKitDoubleBounce(color: Color(0xffF37979),),
            SizedBox(width: 20),
            Text('Adding course...'),
          ],
        ),
      ),
    );
  }

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Add New Course'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Course Name'),
              onChanged: (value) {
                courseName = value;
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Course ID'),
              onChanged: (value) {
                courseId = value;
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Paper Id'),
              onChanged: (value) {
                paperId = value;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            // Show loading indicator
            _showLoadingDialog();

            try {
              String title = 'New Course ${courseId} is Added';
              String body = 'If you want you can Explore it';

              // Add course and send notification
              await createAndStoreNotification(context,title,body);
              await Database().addPaperCourse(PaperCourses(courseId: courseId, courseName: courseName, paperId: paperId));


              Navigator.of(context).pop(); // Close the loading dialog
              Navigator.of(context).pop(); // Close the add course dialog

              // Optionally, show a success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Course added successfully')),
              );

            } catch (e) {
              print('Error adding course: $e');

              // Close the loading dialog and show error message
              Navigator.of(context).pop(); // Close the loading dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error adding course: $e')),
              );
            }
          },
          child: Text('Add'),
        ),
      ],
    ),
  );
}

// Example function to show a local notification

// Add Section Dialog
Future<void> showAddPaperSectionDialog(BuildContext context) async {
  String sectionName = '';
  String sectionUrl = '';
  String sectionDuration = '';
  String sectionId = '';
  String courseId = '';
  String paperId = '';

  // Create a global key for the loading dialog
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Add New Section'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Section Name'),
              onChanged: (value) {
                sectionName = value;
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Section URL'),
              onChanged: (value) {
                sectionUrl = value;
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Section ID'),
              onChanged: (value) {
                sectionId = value;
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Course ID'),
              onChanged: (value) {
                courseId = value;
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Section Duration'),
              onChanged: (value) {
                sectionDuration = value;
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Paper Id'),
              onChanged: (value) {
                paperId = value;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            // Show the loading dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  key: _keyLoader,
                  content: Row(
                    children: <Widget>[
                      SpinKitDoubleBounce(color: Color(0xffF37979),),
                      SizedBox(width: 20),
                      Text('Adding section...'),
                    ],
                  ),
                );
              },
            );

            try {
              // Call your method to add the section
              await Database().addPaperSection(PaperSection(
                courseId: courseId,
                sectionId: sectionId,
                sectionUrl: sectionUrl,
                sectionName: sectionName,
                sectionDuration: sectionDuration,
                paperId: paperId,
              ));
              Navigator.of(context).pop(); // Close the loading dialog
              Navigator.of(context).pop(); // Close the add section dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Section added successfully')),
              );
            } catch (e) {
              Navigator.of(context).pop(); // Close the loading dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error adding section: $e')),
              );
            }
          },
          child: Text('Add'),
        ),
      ],
    ),
  );
}

// Confirmation Dialog
Future<bool> showConfirmationDialog(String message, BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Confirmation'),
      content: SingleChildScrollView(
        child: Text(message),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Confirm'),
        ),
      ],
    ),
  ) ?? false;
}
