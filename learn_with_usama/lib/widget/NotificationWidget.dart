import 'package:flutter/material.dart';

class NotificationWidget extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  NotificationWidget({required this.message, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.notification_important, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Notifications",
                    style: TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: onDismiss,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
