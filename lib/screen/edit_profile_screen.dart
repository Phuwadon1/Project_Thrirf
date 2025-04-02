import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as html;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentEmail;
  final String? currentImageUrl;

  const EditProfileScreen({
    super.key,
    required this.currentName,
    required this.currentEmail,
    required this.currentImageUrl,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isHidden = true;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  Uint8List? _imageBytes;
  XFile? _selectedImage;
  bool _updating = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _emailController = TextEditingController(text: widget.currentEmail);
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _selectedImage = picked;
        _imageBytes = bytes;
      });
    }
  }

  Future<String?> _uploadImage(String uid) async {
    if (_selectedImage == null) return widget.currentImageUrl;

    try {
      final ref = _storage.ref().child('profile_images').child('$uid.jpg');

      if (kIsWeb) {
        final bytes = await _selectedImage!.readAsBytes();
        final blob = html.Blob([bytes] as Uint8List);
        final uploadTask = ref.putBlob(blob);
        final snapshot = await uploadTask.whenComplete(() => {});
        return await snapshot.ref.getDownloadURL();
      } else {
        final bytes = await _selectedImage!.readAsBytes();
        final snapshot = await ref
            .putData(bytes, SettableMetadata(contentType: 'image/jpeg'))
            .timeout(
              const Duration(seconds: 60),
              onTimeout: () {
                throw Exception("Upload timeout");
              },
            );

        if (snapshot.state == TaskState.success) {
          return await ref.getDownloadURL();
        } else {
          throw Exception("Upload failed");
        }
      }
    } catch (e) {
      print("❌ Upload error: $e");
      return widget.currentImageUrl;
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _updating = true);
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      final imageUrl = await _uploadImage(uid);

      await _firestore.collection('users').doc(uid).update({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'profileImage': imageUrl ?? '',
      });

      if (_auth.currentUser!.email != _emailController.text.trim()) {
        await _auth.currentUser!.verifyBeforeUpdateEmail(
          _emailController.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Verification email sent. Please check your new email to confirm before it's updated.",
            ),
          ),
        );
      }

      if (_passwordController.text.trim().isNotEmpty) {
        await _auth.currentUser!.updatePassword(
          _passwordController.text.trim(),
        );
      }

      Navigator.pop(context, {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'imageUrl': imageUrl ?? '',
      });
    } catch (e) {
      print("❌ Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Profile update failed.")));
    } finally {
      setState(() => _updating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> showImage;

    if (_imageBytes != null) {
      showImage = MemoryImage(_imageBytes!);
    } else if (widget.currentImageUrl != null &&
        widget.currentImageUrl!.isNotEmpty) {
      showImage = NetworkImage(widget.currentImageUrl!);
    } else {
      showImage = const AssetImage('images/profilr.jpg');
    }


    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: showImage,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 18,
                            child: const Icon(Icons.camera_alt, size: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: "Full Name"),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Enter your name"
                                : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: "Email"),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Enter your email"
                                : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _isHidden,
                    decoration: InputDecoration(
                      labelText: "New Password (optional)",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isHidden ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isHidden = !_isHidden;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _updating ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_updating)
            Container(
              color: Colors.black, // พื้นหลังดำสนิท
              child: Center(

                child: Lottie.asset(
                  'lottie/animation_success.json',
                  width: 220,
                  height: 220,
                  fit: BoxFit.contain,
                  delegates: LottieDelegates(
                    values: [
                      ValueDelegate.color(
                        const ['**'], // เปลี่ยนสีทุกองค์ประกอบ
                        value: Colors.white, // ใช้สีขาวเพื่อให้ตัดกับพื้นหลัง
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
