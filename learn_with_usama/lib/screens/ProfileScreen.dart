import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp_share/whatsapp_share.dart';

class ProfileScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProfileHeader(),
            SizedBox(height: 20),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  // AppBar Widget
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  // Profile Header Widget
  Widget _buildProfileHeader() {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildBackgroundHeader(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            _buildProfilePicture(),
            SizedBox(height: 10),
            _buildDisplayName(),
            SizedBox(height: 10.0,),
            _buildJobTitle(),
            SizedBox(height: 20),
          ],
        ),
      ],
    );
  }

  // Background for Profile Header
  Widget _buildBackgroundHeader() {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Color(0xffFFD7D7),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
    );
  }

  // Profile Picture Widget
  Widget _buildProfilePicture() {
    return CircleAvatar(
      radius: 60,
      backgroundImage: user?.photoURL != null
          ? NetworkImage(user!.photoURL!)
          : AssetImage('assets/placeholder.png') as ImageProvider,
    );
  }

  // Display Name Widget
  Widget _buildDisplayName() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        user?.displayName ?? 'Anonymous',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Job Title Widget
  Widget _buildJobTitle() {
    return Text(
      "${user?.email}",
      style: TextStyle(
        fontSize: 18,
        color: Colors.grey,
      ),
    );
  }

  // Action Buttons
  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildEditProfileButton(context),
          SizedBox(width: 20),
          _buildInviteFriendsButton(context),
        ],
      ),
    );
  }

  // Edit Profile Button
  Widget _buildEditProfileButton(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addUserDetail');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xffF37979),
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: Text(
          "Edit Profile",
          style: TextStyle(fontSize: 16,
          color: Colors.white),
        ),
      ),
    );
  }

  // Add Friends Button
  Widget _buildInviteFriendsButton(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          isInstalled();
          share();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFF37979),
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: Text(
          "Invite Friend",
          style: TextStyle(fontSize: 16,
          color: Colors.white),
        ),
      ),
    );
  }

  // Method to Share via WhatsApp
  Future<void> isInstalled() async {
    final val = await WhatsappShare.isInstalled(
        package: Package.businessWhatsapp
    );
    print('Whatsapp Business is installed: $val');
  }
  Future<void> share() async {
    await WhatsappShare.share(
      text: 'Whatsapp share text',
      linkUrl: 'https://flutter.dev/',
      phone: '911234567890',
    );
  }
}