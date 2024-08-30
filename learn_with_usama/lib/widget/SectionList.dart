import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/Section.dart';
import '../screens/EditSectionScreen.dart';
import '../services/Course&SectionSevices.dart';
import '../services/database.dart';

class SectionList extends StatefulWidget {
  final Animation<double> animation;
  final List<Section> items;
  final String? selectedItem;
  final void Function(String?)? onSectionTap;
  final FirebaseFirestore firestore;

  const SectionList({
    Key? key,
    required this.animation,
    required this.items,
    this.selectedItem,
    this.onSectionTap,
    required this.firestore,
  }) : super(key: key);

  @override
  State<SectionList> createState() => _SectionListState();
}

class _SectionListState extends State<SectionList> {
  @override
  Widget build(BuildContext context) {
    // Ensure no duplicate sections in the list
    final uniqueItems = widget.items.toSet().toList();
    print(uniqueItems.map((e) => e.sectionName).toList()); // Debug print for list of sections

    return SizeTransition(
      sizeFactor: widget.animation,
      axisAlignment: -1.0,
      child: uniqueItems.isEmpty
          ? _buildEmptyState(context)
          : Column(
        children: uniqueItems.map((section) {
          final bool isSelected = widget.selectedItem != null && widget.selectedItem == section.sectionName;

          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            leading: Icon(
              isSelected ? Icons.stop_circle : Icons.play_circle,
              color: Color(0xffFF8A8A),
            ),
            title: Column(
              children: [
                Text('${section.sectionId}. ${section.sectionName}' ?? 'No Name'),
                Text(
                  'Duration: ${section.sectionDuration}',
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            onTap: () {
              if (widget.onSectionTap != null) {
                widget.onSectionTap!(section.sectionName);
              }
            },
            tileColor: isSelected ? Colors.grey[200] : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      showAddSectionDialog(context);
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      _showEditDialog(context, section);
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      showDeleteSectionDialog(context, section.sectionDoc!);
                    });
                  },
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Section is empty',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {
            // Show add section dialog or navigate to add section screen
            showAddSectionDialog(context);
          },
          child: Text('Add Section'),
        ),
      ],
    );
  }
}

void _showEditDialog(BuildContext context, Section section) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit Unit'),
        content: EditSectionScreen(
          section: section,
        ),
      );
    },
  );
}

void showDeleteSectionDialog(BuildContext context, String sectionId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Section'),
        content: Text('Are you sure you want to delete this section?'),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await Database().deleteSection(sectionId);
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Section deleted successfully')),
                );
              } catch (e) {
                // Handle error gracefully
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error deleting section: $e')),
                );
              }
            },
            child: Text('Delete'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}
