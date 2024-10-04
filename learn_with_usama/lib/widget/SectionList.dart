import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../models/Section.dart';
import '../screens/TheoryExplanationPages/EditSectionScreen.dart';
import '../screens/payHereFormUnit.dart';
import '../services/Course&SectionSevices.dart';
import '../services/database.dart';

class SectionList extends StatefulWidget {
  final Animation<double> animation;
  final List<Section> items;
  final String? selectedItem;
  final void Function(String?)? onSectionTap;
  final FirebaseFirestore firestore;
  final String amount;

  const SectionList({
    Key? key,
    required this.animation,
    required this.items,
    this.selectedItem,
    this.onSectionTap,
    required this.firestore,
    required this.amount,
  }) : super(key: key);

  @override
  State<SectionList> createState() => _SectionListState();
}

class _SectionListState extends State<SectionList> {
  bool _isAdmin = false;
  bool _hasPaid = false;
  Set<String> _paidUnitIds = {}; // Store paid unit IDs here

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
    _checkPaymentStatusForUnits();
  }

  Future<void> _fetchUserRole() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        String role = userDoc['role'];
        setState(() {
          _isAdmin = role == 'Admin';
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user role: $e');
      }
    }
  }

  // Check if the user has paid for specific units
  Future<void> _checkPaymentStatusForUnits() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Query all units where the user has paid
        QuerySnapshot paymentDocs = await FirebaseFirestore.instance
            .collection('units')
            .where('userId', arrayContains: user.uid) // Check if user has access
            .where('paymentStatus', isEqualTo: 'paid')
            .get();

        bool hasAccess = false;

        for (var doc in paymentDocs.docs) {
          final paymentData = doc.data() as Map<String, dynamic>;
          final Timestamp? paymentDate = paymentData['paymentDate'];

          if (paymentDate != null) {
            final DateTime paymentDateTime = paymentDate.toDate();
            final DateTime currentDateTime = DateTime.now();

            // Check if more than 30 days have passed since payment
            if (currentDateTime.difference(paymentDateTime).inDays < 30) {
              // User still has access
              hasAccess = true;
              _paidUnitIds.add(doc['unitNumber']); // Store valid unit ID if needed
            } else {
              // Remove the user's ID from the 'userId' array in this document
              await FirebaseFirestore.instance
                  .collection('units')
                  .doc(doc.id)
                  .update({
                'userId': FieldValue.arrayRemove([user.uid]), // Remove user ID
              });
            }
          }
        }

        // Update the state to reflect access based on payment status
        setState(() {
          _hasPaid = hasAccess; // Update access status based on payment
        });
      }
    } catch (e) {
      print('Error checking payment status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure no duplicate sections in the list
    final uniqueItems = widget.items.toSet().toList();

    return SizeTransition(
      sizeFactor: widget.animation,
      axisAlignment: -1.0,
      child: uniqueItems.isEmpty
          ? _buildEmptyState(context)
          : Column(
        children: uniqueItems.map((section) {
          final bool isSelected = widget.selectedItem != null &&
              widget.selectedItem == section.sectionName;
          final bool hasPaidForThisUnit = _paidUnitIds.contains(section.unitId);
          // Lock sections if the user hasn't paid or isn't an admin
          final bool canAccessSection = hasPaidForThisUnit || _isAdmin;

          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            leading: Icon(
              canAccessSection
                  ? (isSelected ? Icons.stop_circle : Icons.play_circle)
                  : Icons.lock,
              color: canAccessSection
                  ? (isSelected ? Color(0xffF37979) : Colors.grey)
                  : Colors.red,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${section.sectionId}. ${section.sectionName}',
                  style: TextStyle(
                    fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
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
              if (canAccessSection) {
                if (widget.onSectionTap != null) {
                  widget.onSectionTap!(section.sectionName);
                }
              } else {
                _showPaymentRequiredDialog(section.unitId!);
              }
            },
            tileColor:
            isSelected ? Color(0xffF37979).withOpacity(0.1) : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            trailing: _isAdmin ? _buildAdminActions(section) : null,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAdminActions(Section section) {
    return Row(
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
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
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
          if (_isAdmin)
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
          child: SpinKitCubeGrid(color: Color(0xffF37979)),
        );
      },
    );
  }

  void _showPaymentRequiredDialog(String unitId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Required'),
          content: Text('You need to make a payment to access this content.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentFormPageUnit(
                      fixedAmount: widget.amount,
                      unitId: unitId,
                    ),
                  ),
                );
              },
              child: Text('Make Payment'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
