import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:loginfacebook/bloc/authentication_bloc.dart';
import 'package:loginfacebook/events/authentication_event.dart';
import 'package:loginfacebook/states/authentication_state.dart';
import 'package:loginfacebook/repository/account_repository.dart';
import 'package:loginfacebook/view/home_view.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreen createState() => new _SignInScreen();
}

class _SignInScreen extends State<SignInScreen> {
  final AccountRepository _accountRepository = AccountRepository();
  AuthenticateBloc _authenticationBloc;
  @override
  void initState() {
    super.initState();
    _authenticationBloc =
        AuthenticateBloc(accountRepository: _accountRepository);
    _authenticationBloc.add(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: _authenticationBloc,
        listener: (BuildContext context, AuthenticationState state) {
          if (state is Authenticated == true) {
            // Navigator.pop(
            //   context,
            //   MaterialPageRoute(builder: (context) => SignInScreen()),
            // );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
        },
        child: new Stack(children: [
          new Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/pngtree-purple-brilliant-background-image_257402.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(             
              top: MediaQuery.of(context).size.height*0.25,
              
              child: new Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(0.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: new Image(
                        image: new AssetImage("assets/logo_aus.png"),
                        width: MediaQuery.of(context).size.width*0.25,
                        height: MediaQuery.of(context).size.width*0.25,
                        color: null,
                        fit: BoxFit.fill,
                        alignment: Alignment.center,                     
                    ),
                    ) 
                  ]
                )
              ),
              ),             
          Positioned(           
              top: MediaQuery.of(context).size.height*0.43,
              child: new Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(0.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text("Audio Streaming", style: TextStyle(fontSize: 20, color: Colors.white, decoration: TextDecoration.none), )
                  ]
                )
              ),

             ),
          Positioned(
              width: 300,
              height: 55,
              top: MediaQuery.of(context).size.height*0.7,
              left: 60,
              child: new SignInButton(
                Buttons.Google,
                text: "Sign in with Google",
                onPressed: () {
                  _authenticationBloc.add(
                    SignInWithGoogle(),
                  );
                }, //on press
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)),
              )),
          Positioned(
              width: 300,
              height: 55,
              top: MediaQuery.of(context).size.height*0.81,
              left: 60,
              child: new SignInButton(
                Buttons.Facebook,
                text: "Sign in with FaceBook",
                onPressed: () {
                  _authenticationBloc.add(
                    LoggedInWithFacebook(),
                  );
                }, //on press
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)),
              ))
        ]));
  }
}
