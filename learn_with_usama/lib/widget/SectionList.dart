import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/Section.dart';
import '../services/Course&SectionSevices.dart';

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
      child: Column(
        children: uniqueItems.map((section) {
          final bool isSelected = widget.selectedItem != null && widget.selectedItem == section.sectionName;

          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            leading: Icon(
              isSelected ? Icons.stop_circle : Icons.play_circle,
              color: Color(0xffFF8A8A),
            ),
            title: Text(section.sectionName ?? 'No Name'),
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
                      showAddSectionDialog(section.courseId!, context, widget.firestore);
                    });

                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                       showEditSectionDialog(section, context, widget.firestore);
                    });
                    },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(()  {
                       deleteSection(section, widget.firestore, context);
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
}

