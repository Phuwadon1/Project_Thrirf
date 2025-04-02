import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cool_alert/cool_alert.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Register extends StatefulWidget {
  static const routeName = '/register';

  const Register({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<Register> {
  XFile? _selectedImage;
  Uint8List? _imageBytes;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  late final SharedPreferences prefs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _isHidden = true;
  bool _registeringStatus = false;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  void loadSettings() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // 🔽 ลดคุณภาพเพื่อให้ upload เร็วขึ้น
    );

    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _selectedImage = picked;
        _imageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: _pickProfileImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage:
                          _imageBytes != null
                              ? MemoryImage(_imageBytes!)
                              : null,
                      child: Stack(
                        children: [
                          if (_imageBytes == null)
                            const Center(
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white,
                              child: const Icon(Icons.add_a_photo, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  // Name Input
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Full Name',
                      icon: Icon(Icons.person),
                    ),
                    controller: _name,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Please enter your full name'
                                : null,
                  ),
                  const SizedBox(height: 5.0),

                  // Email Input
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      icon: Icon(Icons.email_outlined),
                    ),
                    controller: _email,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter an email';
                      final regex = RegExp(
                        r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b',
                      );
                      return regex.hasMatch(value)
                          ? null
                          : 'Please enter a valid email';
                    },
                  ),
                  const SizedBox(height: 5.0),

                  // Password Input
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                      icon: const Icon(Icons.vpn_key),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isHidden = !_isHidden;
                          });
                        },
                        icon: Icon(
                          _isHidden ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                    controller: _password,
                    obscureText: _isHidden,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter a password';
                      if (value.length < 6)
                        return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child:
                        _registeringStatus
                            ? SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                child: const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.blue, // สีหมุนเวลาโหลด
                                  ),
                                ),
                              ),
                            )
                            : SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => _registeringStatus = true);

                                    try {
                                      UserCredential userCredential =
                                          await _auth
                                              .createUserWithEmailAndPassword(
                                                email: _email.text,
                                                password: _password.text,
                                              );
                                      User? user = userCredential.user;
                                      String? imageUrl;

                                      if (_selectedImage != null) {
                                        final ref = _storage.ref().child(
                                          'profile_images/${user!.uid}.jpg',
                                        );
                                        final bytes =
                                            await _selectedImage!.readAsBytes();
                                        final snapshot = await ref
                                            .putData(bytes)
                                            .timeout(
                                              const Duration(seconds: 15),
                                              onTimeout:
                                                  () =>
                                                      throw Exception(
                                                        "Upload timeout",
                                                      ),
                                            );

                                        if (snapshot.state ==
                                            TaskState.success) {
                                          imageUrl = await ref.getDownloadURL();
                                        }
                                      }

                                      await _firestore
                                          .collection('users')
                                          .doc(user!.uid)
                                          .set({
                                            'name': _name.text.trim(),
                                            'email': _email.text.trim(),
                                            'uid': user.uid,
                                            'profileImage': imageUrl ?? '',
                                          });

                                      CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.success,
                                        text: 'Create new user successful!',
                                        autoCloseDuration: const Duration(
                                          seconds: 2,
                                        ),
                                      );

                                      Future.delayed(
                                        const Duration(seconds: 2),
                                        () {
                                          Navigator.pop(context);
                                        },
                                      );
                                    } catch (e) {
                                      print("❌ Error: $e");
                                      CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text: "Something went wrong.",
                                      );
                                    } finally {
                                      setState(
                                        () => _registeringStatus = false,
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                ),
                                child: const Text(
                                  'Register 😘',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
