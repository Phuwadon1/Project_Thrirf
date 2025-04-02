import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thriftpoint/provider/favorite_provider.dart';
import 'package:thriftpoint/screen/login.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:thriftpoint/screen/profile_screen.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Future.delayed(Duration(seconds: 3));
  FlutterNativeSplash.remove();
  // รอให้ Firebase ถูกตั้งค่าเรียบร้อยก่อนที่แอปจะเริ่มทำงาน
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyC0e1ifEn62ILAE7d1kIkRDx4MAt41XrgE",
      authDomain: "test-c0003.firebaseapp.com",
      databaseURL: "https://test-c0003-default-rtdb.firebaseio.com",
      projectId: "test-c0003",
      storageBucket: "test-c0003.firebasestorage.app",
      messagingSenderId: "966265069519",
      appId: "1:966265069519:web:fa74b94bcf613f1574fcba",
      measurementId: "G-0WFVJDPQQR",
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => FavoriteProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
