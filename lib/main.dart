import 'package:flutter/material.dart';
import 'package:rock_and_morty/src/theme/theme.dart';

import 'src/screens/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rick and Morty',
      theme: rickAndMortyTheme,
      home: HomeScreen(),
    );
  }
}
