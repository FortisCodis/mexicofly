import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mexicofly/bloc/game/game_cubit.dart';
import 'package:mexicofly/main_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => GameCubit(),
        child: const MaterialApp(
          title: "FlappyGame",
          home: MainPage(),
          debugShowCheckedModeBanner: false,
        ));
  }
}
