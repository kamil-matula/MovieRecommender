import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movie_recommender/core/navigation_manager.dart';
import 'package:movie_recommender/firebase_options.dart';
import 'package:movie_recommender/view/widgets/keyboard_dismisser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movie Recommender',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const NavigationManager(),
      ),
    );
  }
}
