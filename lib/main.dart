import 'package:contact_plus_apk/view/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_preview/device_preview.dart';

// Pages
import 'package:contact_plus_apk/service/firebase_options.dart';
import 'package:contact_plus_apk/view/login.dart';
import 'package:contact_plus_apk/view/splashScreen.dart';
// import 'package:contact_plus_apk/view/MyContactPage.dart';
import 'package:contact_plus_apk/view/add_contact.dart';
import 'package:contact_plus_apk/view/favorite_contact.dart';
import 'package:contact_plus_apk/view/profile_user.dart';
import 'package:contact_plus_apk/view/detail_contact.dart';
import 'package:contact_plus_apk/view/edit_contact.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => const MainApp(),
  ));
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
      initialRoute: 'splash_screen',
      routes: {
        'splash_screen': (context) => const SplashScreen(),
        'login_screen': (context) => const LoginPage(),
        'register_screen': (context) => const RegisterPage(),
        // 'dashboard_user': (context) => const MyContactPage(user: null,),
        'add_contact': (context) => AddContact(user: ModalRoute.of(context)!.settings.arguments as User),
        'favorite_pages': (context) => FavoriteContact(user: ModalRoute.of(context)!.settings.arguments as User),
        'profile_pages': (context) => ProfileUser(user: ModalRoute.of(context)!.settings.arguments as User),
        'detail_contact': (context) => DetailContact(
              contactId: ModalRoute.of(context)?.settings.arguments as String,
            ),
        'edit_contact': (context) => const EditContact(),
      },
    );
  }
}
