import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_recommender/constants/constant_colors.dart';
import 'package:movie_recommender/core/navigation_manager.dart';
import 'package:movie_recommender/firebase_options.dart';
import 'package:movie_recommender/view/widgets/keyboard_dismisser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: STATUS_BAR_COLOR,
    ),
  );
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
        theme: ThemeData(primarySwatch: PRIMARY_SWATCH_COLOR),
        home: const NavigationManager(),
      ),
    );
  }
}
