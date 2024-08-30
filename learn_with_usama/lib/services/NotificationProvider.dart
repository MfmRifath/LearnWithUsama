import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Notification.dart';

class NotificationProvider with ChangeNotifier {
  List<MyNotification> _notifications = [];

  List<MyNotification> get notifications => _notifications;

  NotificationProvider() {
    fetchNotifications();
    cleanupOldNotifications();
  }

  Future<void> fetchNotifications() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('notifications').get();
    _notifications = snapshot.docs.map((doc) => MyNotification.fromMap(doc.data() as Map<String, dynamic>)).toList();
    notifyListeners();
  }

  Future<void> addNotification(MyNotification notification) async {
    await FirebaseFirestore.instance.collection('notifications').add(notification.toMap());
    _notifications.add(notification);
    notifyListeners();
  }

  Future<void> cleanupOldNotifications() async {
    final now = DateTime.now();
    final cutoffDate = now.subtract(Duration(days: 10));

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .where('date', isLessThan: cutoffDate.toIso8601String())
        .get();

    for (var doc in snapshot.docs) {
      await FirebaseFirestore.instance.collection('notifications').doc(doc.id).delete();
    }

    // Refresh the notification list after cleanup
    fetchNotifications();
  }
}
