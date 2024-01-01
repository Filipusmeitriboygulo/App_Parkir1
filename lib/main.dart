import 'package:app_parkir/firebase_options.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
 );
  runApp(MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
