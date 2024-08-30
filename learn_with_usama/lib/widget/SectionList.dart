import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
              color: isSelected ? Color(0xffF37979) : Colors.grey,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${section.sectionId}. ${section.sectionName}',
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Text(
                  'Duration: ${section.sectionDuration} Minutes',
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
            tileColor: isSelected ? Color(0xffF37979).withOpacity(0.1) : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  tooltip: 'Add Section',
                  onPressed: () => showAddSectionDialog(context),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  tooltip: 'Edit Section',
                  onPressed: () => _showEditDialog(context, section),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  tooltip: 'Delete Section',
                  onPressed: () => _showDeleteConfirmation(context, section.sectionDoc!),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 64.0, color: Colors.grey),
          SizedBox(height: 16.0),
          Text(
            'No sections available.',
            style: TextStyle(fontSize: 18.0, color: Colors.grey),
          ),
          SizedBox(height: 16.0),
          ElevatedButton.icon(
            onPressed: () => showAddSectionDialog(context),
            icon: Icon(Icons.add),
            label: Text('Add Section'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffF37979),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Section section) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Section'),
          content: EditSectionScreen(section: section),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, String sectionId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Section'),
          content: Text('Are you sure you want to delete this section?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                _showLoadingDialog(context);
                try {
                  await Database().deleteSection(sectionId);
                  Navigator.of(context).pop(); // Close the loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Section deleted successfully')),
                  );
                } catch (e) {
                  Navigator.of(context).pop(); // Close the loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting section: $e')),
                  );
                }
              },
              child: Text('Delete'),
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
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

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: SpinKitCubeGrid(),
        );
      },
    );
  }
}
