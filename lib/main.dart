import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_recommender/constants/colors.dart';
import 'package:movie_recommender/core/auth/auth_cubit.dart';
import 'package:movie_recommender/core/navigation_manager.dart';
import 'package:movie_recommender/firebase_options.dart';
import 'package:movie_recommender/view/widgets/keyboard_dismisser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: CustomColors.magneticBlue),
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: KeyboardDismisser(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Movie Recommender',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const NavigationManager(),
        ),
      ),
    );
  }
}
