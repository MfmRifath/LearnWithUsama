import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/Section.dart';

class SectionList extends StatelessWidget {
  final Animation<double> animation;
  final List<Section> items;
  final String? selectedItem;
  final void Function(String?)? onSectionTap;


  const SectionList({
    Key? key,
    required this.animation,
    required this.items,
    this.selectedItem,
    this.onSectionTap,

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
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            leading: Icon(
              isSelected ? Icons.stop_circle : Icons.play_circle,
              color: Color(0xffFF8A8A),
            ),
            title: Text(section.sectionName ?? 'No Name'),
            onTap: () {
              if (onSectionTap != null) {
                onSectionTap!(section.sectionName);
              }
            },
            tileColor: isSelected ? Colors.grey[200] : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          );
        }).toList(),
      ),
    );
  }
}
