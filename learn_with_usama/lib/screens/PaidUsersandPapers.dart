import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaidUsersAndPapersScreen extends StatefulWidget {
  @override
  _PaidUsersAndPapersScreenState createState() => _PaidUsersAndPapersScreenState();
}

class _PaidUsersAndPapersScreenState extends State<PaidUsersAndPapersScreen> {
  bool isLoading = true;
  bool errorOccurred = false;
  List<Map<String, dynamic>> paidUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchPaidUsersAndUnits();
  }

  Future<void> _fetchPaidUsersAndUnits() async {
    setState(() {
      isLoading = true;
      errorOccurred = false;
    });

    try {
      print('Fetching users...');
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').get();
      List<Map<String, dynamic>> usersWithPaidUnits = [];

      for (var userDoc in userSnapshot.docs) {
        String userId = userDoc.id;
        String userName = userDoc['displayName'] ?? 'Unnamed User';
        print('User ID: $userId, User Name: $userName');

        QuerySnapshot unitSnapshot = await FirebaseFirestore.instance
            .collection('papers')
            .where('userId', arrayContains: userId) // Fix this condition
            .where('paymentStatus', isEqualTo: 'paid')
            .get();

        List<String> paidPaperIds = unitSnapshot.docs.map((doc) => doc['paperId'] as String).toList();

        if (paidPaperIds.isNotEmpty) {
          usersWithPaidUnits.add({
            'userName': userName,
            'paidPapers': paidPaperIds,
          });
        }
      }

      setState(() {
        paidUsers = usersWithPaidUnits;
      });
    } catch (e) {
      print('Error fetching paid users and units: $e');
      setState(() {
        errorOccurred = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paid Users and Papers Class'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading paid users and units...'),
          ],
        ),
      )
          : errorOccurred
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error fetching data. Please try again.'),
            ElevatedButton(
              onPressed: _fetchPaidUsersAndUnits,
              child: Text('Retry'),
            ),
          ],
        ),
      )
          : paidUsers.isEmpty
          ? Center(child: Text('No Paid Users Found'))
          : ListView.builder(
        itemCount: paidUsers.length,
        itemBuilder: (context, index) {
          final user = paidUsers[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ExpansionTile(
              title: Row(
                children: [
                  Icon(Icons.person, color: Colors.teal),
                  SizedBox(width: 8),
                  Text(user['userName']),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: user['paidPapers']
                        .map<Widget>((paperId) => Text('- Paper ID: $paperId'))
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
