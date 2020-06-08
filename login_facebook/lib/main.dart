import 'package:flutter/material.dart';
import 'authenticate.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Audio Streaming',
      theme: new ThemeData(
        brightness: Brightness.dark,
        primaryColorBrightness: Brightness.dark,
      ),
      home: new LaunchScreen(),
    );
  }
}

class LaunchScreen extends StatefulWidget {
  @override
  _LaunchScreenState createState() => new _LaunchScreenState();
}
class _LaunchScreenState extends State<LaunchScreen> {
 // PageController _pageController = new PageController(initialPage: 2);

  @override
  build(BuildContext context) {
    return new Stack(
      children: [
        new Container(
          decoration:  BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/pngtree-purple-brilliant-background-image_257402.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          width:100,
          top: 350,
          left: 140,
          child:  new Image(
            image: new AssetImage("assets/love-icon.png"),
            width:  100,
            height:  100,
            color: null,
            fit: BoxFit.fitHeight,
            alignment: Alignment.center,
          )
          ),
          Positioned(
          width:100,
          top: 328,
          left: 220,
          child:  new Image(
            image: new AssetImage("assets/high.png"),
            width:  100,
            height:  180,
            color: null,
            fit: BoxFit.fitHeight,
            alignment: Alignment.center,
          )
          ),
          Positioned(
            width:300,
            height: 55,
            bottom: 200,
            left: 60,
            child:  
              new SignInButton(
                Buttons.Google,
                text: "Sign in with Google",
                onPressed:  () {
                      signInWithGoogle(context).catchError(() {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return LaunchScreen();
                            },
                          ),
                        );
                      });
                    }
                ,//on press
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              )
          ),
          Positioned(
            width:300,
            height: 55,
            bottom: 100,
            left: 60,
            child:  
              new SignInButton(
                Buttons.Facebook,
                text: "Sign in with FaceBook",
                onPressed:  () {
                      loginWithFacebook(context).catchError(() {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return LaunchScreen();
                            },
                          ),
                        );
                      });
                    }
                ,//on press
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              )
          )
      ]
    );
  }
 
}


