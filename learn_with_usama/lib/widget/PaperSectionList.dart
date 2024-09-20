import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:learn_with_usama/screens/payHereFormPaper.dart';
import '../models/PaperSection.dart';
import '../screens/PaperScreens/PaperEditSectionScreen.dart';
import '../services/PaperCourse&SectionService.dart';
import '../services/database.dart';

class PaperSectionList extends StatefulWidget {
  final Animation<double> animation;
  final List<PaperSection> items;
  final String? selectedItem;
  final void Function(String?)? onSectionTap;
  final FirebaseFirestore firestore;
  final String amount;

  const PaperSectionList({
    Key? key,
    required this.animation,
    required this.items,
    this.selectedItem,
    this.onSectionTap,
    required this.firestore, required this.amount,
  }) : super(key: key);

  @override
  State<PaperSectionList> createState() => _SectionListState();
}

class _SectionListState extends State<PaperSectionList> {
  bool _isAdmin = false;
  bool _hasPaid = false;
  Set<String> _paidUnitIds = {}; // Store paid unit IDs here

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
    _checkPaymentStatusForPapers();
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
  Future<void> _checkPaymentStatusForPapers() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot paymentDocs = await FirebaseFirestore.instance
            .collection('papers')
            .where('userId', isEqualTo: user.uid)
            .where('paymentStatus', isEqualTo: 'paid')
            .get();

        for (var doc in paymentDocs.docs) {
          final paymentData = doc.data() as Map<String, dynamic>;
          final Timestamp? paymentDate = paymentData['paymentDate'];

          if (paymentDate != null) {
            final DateTime paymentDateTime = paymentDate.toDate();
            final DateTime currentDateTime = DateTime.now();

            // Check if more than 30 days have passed since payment
            if (currentDateTime.difference(paymentDateTime).inDays >= 30) {
              // Update payment status to "not paid" if more than one month has passed
              await FirebaseFirestore.instance
                  .collection('papers')
                  .doc(doc.id)
                  .update({
                'paymentStatus': 'not paid',
              });
            } else {
              // If the payment is still valid, store the unit ID as paid
              _paidUnitIds.add(doc.id);
            }
          }
        }

        setState(() {
          _hasPaid = _paidUnitIds.isNotEmpty;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking payment status: $e');
      }
    }
  }


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
          final bool hasPaidForThisUnit = _paidUnitIds.contains(section.paperId);
          // Lock sections if the user hasn't paid or isn't an admin
          final bool canAccessSection = hasPaidForThisUnit || _isAdmin;

          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            leading:Icon(
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
              if (_hasPaid || _isAdmin) {
                if (widget.onSectionTap != null) {
                  widget.onSectionTap!(section.sectionName);
                }
              } else {
                _showPaymentRequiredDialog(section.paperId!);
              }
            },
            tileColor: isSelected ? Color(0xffF37979).withOpacity(0.1) : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            trailing: _isAdmin ? _buildAdminActions(section) : null,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAdminActions(PaperSection section) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.add),
          tooltip: 'Add Section',
          onPressed: () => showAddPaperSectionDialog(context),
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
          if (_isAdmin)
            ElevatedButton.icon(
              onPressed: () => showAddPaperSectionDialog(context),
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

  void _showEditDialog(BuildContext context, PaperSection section) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Section'),
          content: PaperEditSectionScreen(section: section),
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
                try {
                  await Database().deletePaperSection(sectionId);
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

  _showPaymentRequiredDialog(String paperId) {
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentFormPagePaper(fixedAmount: widget.amount, paperId:paperId )));
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
