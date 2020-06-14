import 'package:flutter/material.dart';
import 'package:loginfacebook/view/sign_in_view.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

    @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Audio Streaming',
      theme: new ThemeData(
        brightness: Brightness.dark,
        primaryColorBrightness: Brightness.dark,
      ),
      home: new SignInScreen(),
    );
  }
}

