import 'package:flutter/material.dart';
import 'package:sinflix/views/screens/login.dart';
import 'package:sinflix/views/screens/home.dart';
import 'package:sinflix/views/screens/register.dart';
import 'package:sinflix/views/screens/add_profile_photo.dart';
import 'package:sinflix/views/screens/profile.dart';
import 'package:sinflix/views/screens/movies.dart';
import 'utils/constants/theme.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SinFlix',
      theme: appTheme,
      home: const LoginView(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/profile-photo': (context) => const ProfilePhotoView(),
        '/home': (context) => const HomeView(),
        '/profile': (context) => const ProfileView(),
        '/movies': (context) => const MoviesView(),
      },
    );
  }
}