import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thriftpoint/botton/navigation_page.dart';
import 'package:thriftpoint/screen/home_screen.dart';
import 'register.dart';
import 'package:cool_alert/cool_alert.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // เพิ่ม Firebase Auth

  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _isHidden = true;
  bool _authenticatingStatus = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _authenticatingStatus = true;
      });

      try {
        await _auth.signInWithEmailAndPassword(
          email: _email.text.trim(),
          password: _password.text.trim(),
        );

        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text: 'Login Successful',
          autoCloseDuration: const Duration(seconds: 2),
        );

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => const BottomNavigationBarPage(title: 'Main'),
            ),
          );
        });
      } on FirebaseAuthException catch (e) {
        print("Firebase Auth Error: ${e.message}");
        String errorMessage = 'Login failed. Please try again.';

        if (e.code == 'user-not-found') {
          errorMessage = 'No user found with this email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Incorrect password. Please try again.';
        }

        setState(() {
          _authenticatingStatus = false; // ✅ หยุดโหลดเมื่อ error
        });

        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: errorMessage,
        );
      } catch (e) {
        print("Unexpected error: $e");

        setState(() {
          _authenticatingStatus = false; // ✅ หยุดโหลดเมื่อ error
        });

        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: 'An unexpected error occurred.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Image.asset(
                    'images/Logo.jpg',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                      icon: Icon(Icons.email_outlined),
                    ),
                    controller: _email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 5.0),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                      icon: Icon(Icons.vpn_key),
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
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child:
                        _authenticatingStatus
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
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                            : SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                ),
                                child: const Text(
                                  'Login 😍',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                  ),

                  SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Or '),
                      InkWell(
                        child: Text(
                          'Register',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
                          );
                        },
                      ),
                    ],
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
