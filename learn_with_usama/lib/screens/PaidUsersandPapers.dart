import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaidUsersAndPapersScreen extends StatefulWidget {
  @override
  _PaidUsersAndUnitsScreenState createState() => _PaidUsersAndUnitsScreenState();
}

class _PaidUsersAndUnitsScreenState extends State<PaidUsersAndPapersScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> paidUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchPaidUsersAndUnits();
  }

  Future<void> _fetchPaidUsersAndUnits() async {
    try {
      // Fetch users with payment status 'paid'
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('paymentStatus', isEqualTo: 'paid')
          .get();

      List<Map<String, dynamic>> usersWithUnits = [];

      // Iterate over each user document
      for (var userDoc in userSnapshot.docs) {
        String userId = userDoc.id;
        String userName = userDoc['displayName'] ?? 'Unnamed User'; // Use displayName field from AppUser

        // Fetch units associated with the user and payment status 'paid'
        QuerySnapshot unitSnapshot = await FirebaseFirestore.instance
            .collection('papers')
            .where('userId', isEqualTo: userId)
            .where('paymentStatus', isEqualTo: 'paid')
            .get();

        // Extract the paid unit IDs
        List<String> paidPaperIds = unitSnapshot.docs.map((doc) => doc['paperId'] as String).toList();

        usersWithUnits.add({
          'userName': userName,
          'paidPapers': paidPaperIds,
        });
      }

      // Update state with the fetched data
      setState(() {
        paidUsers = usersWithUnits;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching paid users and papers: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paid Users and Units'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : paidUsers.isEmpty
          ? Center(child: Text('No Paid Users Found'))
          : ListView.builder(
        itemCount: paidUsers.length,
        itemBuilder: (context, index) {
          final user = paidUsers[index];
          return ExpansionTile(
            title: Text(user['userName']),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: user['paidPapers']
                      .map<Widget>((paperId) => Text('- Paper ID: $paperId'))
                      .toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
