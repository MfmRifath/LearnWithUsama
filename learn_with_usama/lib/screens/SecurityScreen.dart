import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SecurityScreen extends StatefulWidget {
  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Security'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
      ),
      body: ListView(
        children: [
          _buildSecuritySection(
            context,
            title: 'Password',
            tiles: [
              _buildSecurityTile(
                context,
                icon: Icons.lock_outline,
                title: 'Change Password',
                onTap: () => _changePassword(context),
              ),
            ],
          ),
          _buildDivider(),
          _buildSecuritySection(
            context,
            title: 'Two-Factor Authentication',
            tiles: [
              _buildSecurityTile(
                context,
                icon: Icons.security_outlined,
                title: 'Enable Two-Factor Authentication',
                onTap: () => _enableTwoFactorAuth(context),
              ),
            ],
          ),
          _buildDivider(),
          _buildSecuritySection(
            context,
            title: 'Linked Devices',
            tiles: [
              _buildSecurityTile(
                context,
                icon: Icons.devices_other_outlined,
                title: 'Manage Linked Devices',
                onTap: () => _viewLinkedDevices(context),
              ),
            ],
          ),
          _buildDivider(),
          _buildSecuritySection(
            context,
            title: 'Account Activity',
            tiles: [
              _buildSecurityTile(
                context,
                icon: Icons.access_time_outlined,
                title: 'View Account Activity',
                onTap: ()  => _viewAccountActivity(context)
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _changePassword(BuildContext context) async {
    TextEditingController _passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Password'),
        content: TextField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: 'New Password'),
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                User? user = _auth.currentUser;
                if (user != null) {
                  await user.updatePassword(_passwordController.text);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Password updated successfully'),
                    backgroundColor: Colors.green,
                  ));
                }
              } catch (e) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Error: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ));
              }
            },
            child: Text('Change'),
          ),
        ],
      ),
    );
  }

  void _enableTwoFactorAuth(BuildContext context) async {
    TextEditingController _phoneController = TextEditingController();
    String verificationId = "";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enable Two-Factor Authentication'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _auth.verifyPhoneNumber(
                  phoneNumber: _phoneController.text,
                  verificationCompleted: (PhoneAuthCredential credential) async {
                    await _auth.currentUser?.linkWithCredential(credential);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Phone number linked successfully'),
                      backgroundColor: Colors.green,
                    ));
                  },
                  verificationFailed: (FirebaseAuthException e) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Error: ${e.message}'),
                      backgroundColor: Colors.red,
                    ));
                  },
                  codeSent: (String verId, int? resendToken) {
                    verificationId = verId;
                    Navigator.of(context).pop();
                    _enterVerificationCode(context, verificationId);
                  },
                  codeAutoRetrievalTimeout: (String verId) {},
                );
              },
              child: Text('Send Verification Code'),
            ),
          ],
        ),
      ),
    );
  }

  void _enterVerificationCode(BuildContext context, String verificationId) {
    TextEditingController _codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter Verification Code'),
        content: TextField(
          controller: _codeController,
          decoration: InputDecoration(labelText: 'Verification Code'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: verificationId,
                  smsCode: _codeController.text,
                );
                await _auth.currentUser?.linkWithCredential(credential);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Phone number verified successfully'),
                  backgroundColor: Colors.green,
                ));
              } catch (e) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Error: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ));
              }
            },
            child: Text('Verify'),
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySection(BuildContext context, {required String title, required List<Widget> tiles}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: Colors.grey.shade200,
            width: double.infinity,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          Column(children: tiles),
        ],
      ),
    );
  }

  Widget _buildSecurityTile(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title, style: TextStyle(fontSize: 16)),
      onTap: onTap,
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade600),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
    );
  }

  Divider _buildDivider() {
    return Divider(thickness: 1.0, color: Colors.grey.shade300, height: 20.0);
  }
}
// Manage Linked Devices
void _viewLinkedDevices(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => LinkedDevicesScreen()),
  );
}

// Account Activity
void _viewAccountActivity(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => AccountActivityScreen()),
  );
}

Widget _buildSecuritySection(BuildContext context, {required String title, required List<Widget> tiles}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          color: Colors.grey.shade200,
          width: double.infinity,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
        ),
        Column(children: tiles),
      ],
    ),
  );
}

Widget _buildSecurityTile(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
  return ListTile(
    leading: Icon(icon, color: Theme.of(context).primaryColor),
    title: Text(title, style: TextStyle(fontSize: 16)),
    onTap: onTap,
    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade600),
    tileColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
  );
}

Divider _buildDivider() {
  return Divider(thickness: 1.0, color: Colors.grey.shade300, height: 20.0);
}


class LinkedDevicesScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Linked Devices')),
      body: StreamBuilder(
        stream: _firestore
            .collection('users')
            .doc(_auth.currentUser?.uid)
            .collection('devices')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No linked devices found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var device = snapshot.data!.docs[index];
              return ListTile(
                title: Text(device['deviceName']),
                subtitle: Text('Last active: ${device['lastActive'].toDate()}'),
                trailing: IconButton(
                  icon: Icon(Icons.logout, color: Colors.red),
                  onPressed: () => _unlinkDevice(context, device.id),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _unlinkDevice(BuildContext context, String deviceId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Unlink Device'),
        content: Text('Are you sure you want to unlink this device?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _firestore
                    .collection('users')
                    .doc(_auth.currentUser?.uid)
                    .collection('devices')
                    .doc(deviceId)
                    .delete();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Device unlinked successfully'),
                  backgroundColor: Colors.green,
                ));
              } catch (e) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Error: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ));
              }
            },
            child: Text('Unlink'),
          ),
        ],
      ),
    );
  }
}

class AccountActivityScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account Activity')),
      body: StreamBuilder(
        stream: _firestore
            .collection('users')
            .doc(_auth.currentUser?.uid)
            .collection('activities')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No account activity found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var activity = snapshot.data!.docs[index];
              return ListTile(
                title: Text(activity['activityType']),
                subtitle: Text('${activity['timestamp'].toDate()}'),
                leading: Icon(Icons.access_time, color: Theme.of(context).primaryColor),
              );
            },
          );
        },
      ),
    );
  }
}