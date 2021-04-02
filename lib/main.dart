import 'package:flutter/material.dart';
import 'screens/screens.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.white,
      ),
      home: HomeScreen(),
    );
  }
}
