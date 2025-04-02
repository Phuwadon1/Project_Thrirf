import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thriftpoint/screen/edit_profile_screen.dart';
import 'package:thriftpoint/screen/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String userName = '';
  String userEmail = '';
  String? imageUrl;
  bool isLoading = true;
  double userRating = 0.0; // ⭐ คะแนนของผู้ใช้

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final snapshot = await _firestore.collection('users').doc(uid).get();
      final data = snapshot.data();
      if (data != null) {
        setState(() {
          userName = data['name'] ?? '';
          userEmail = data['email'] ?? '';
          imageUrl = data['profileImage'];
          userRating = (data['userRating'] ?? 0).toDouble(); // 👈 เพิ่มตรงนี้
        });
      }
    } catch (e) {
      print('Fetch profile error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedImage != null) {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      final ref = _storage.ref().child('profile_images').child('$uid.jpg');
      await ref.putFile(File(pickedImage.path));
      final downloadURL = await ref.getDownloadURL();

      await _firestore.collection('users').doc(uid).update({
        'profileImage': downloadURL,
      });

      setState(() {
        imageUrl = downloadURL;
      });
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SpinKitFadingCircle(color: Colors.blue, size: 60.0),
        ),
      );
    }


    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ไม่ให้แตะเพื่อเปลี่ยนภาพได้ — เอา GestureDetector ออก
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage:
                        (imageUrl != null && imageUrl!.isNotEmpty)
                            ? NetworkImage(imageUrl!)
                            : const AssetImage('images/profilr.jpg')
                                as ImageProvider,
                  ),
                ],
              ),

              const SizedBox(height: 15),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                userEmail,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              const Text(
                'Rating the application',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15),
              RatingBar.builder(
                initialRating: userRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder:
                    (context, _) => const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) async {
                  setState(() {
                    userRating = rating;
                  });

                  final uid = _auth.currentUser?.uid;
                  if (uid != null) {
                    await _firestore.collection('users').doc(uid).update({
                      'userRating': rating,
                    });
                  }
                },
              ),

              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text(
                  "Edit Profile",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => EditProfileScreen(
                            currentName: userName,
                            currentEmail: userEmail,
                            currentImageUrl: imageUrl,
                          ),
                    ),
                  );

                  if (result != null && result is Map<String, dynamic>) {
                    setState(() {
                      userName = result['name'];
                      userEmail = result['email'];
                      imageUrl = result['imageUrl'];
                    });
                  }
                },
              ),

              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
