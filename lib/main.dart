import 'package:contact_plus_apk/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:contact_plus_apk/firebase_options.dart';
import 'package:contact_plus_apk/login.dart';
import 'package:contact_plus_apk/splashScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CONTACT+',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: 'splash_screen', // Splash screen yang pertama kali tampil
      routes: {
        'splash_screen': (context) => const SplashScreen(),
        'login_screen': (context) => const LoginPage(),
        'register_screen': (context) => const RegisterPage(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  void _checkIfLoggedIn() async {
    // Cek apakah user sudah login
    final user = FirebaseAuth.instance.currentUser;
    await Future.delayed(
        const Duration(seconds: 3)); // Delay untuk splash screen
    if (user != null) {
      // Jika sudah login, arahkan ke MyContactPage
      Navigator.pushReplacementNamed(context, 'login_screen');
    } else {
      // Jika belum login, arahkan ke login screen
      Navigator.pushReplacementNamed(context, 'login_screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF23253A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              "CONTACT+",
              style: TextStyle(color: Colors.white, fontSize: 32),
            ),
          ],
        ),
      ),
    );
  }
}
