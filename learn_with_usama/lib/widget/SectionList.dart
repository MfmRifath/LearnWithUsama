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
          final bool isSelected = selectedItem == section.sectionName;

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
