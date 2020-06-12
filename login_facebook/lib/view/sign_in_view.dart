import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:loginfacebook/bloc/authentication_bloc.dart';
import 'package:loginfacebook/bloc/authentication_event.dart';
import 'package:loginfacebook/bloc/authentication_state.dart';
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
    _authenticationBloc.dispatch(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: _authenticationBloc,
        listener: (BuildContext context, AuthenticationState state) {
          if (state is Authenticated == true) {
            Navigator.push(
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
              width: 100,
              top: 350,
              left: 140,
              child: new Image(
                image: new AssetImage("assets/love-icon.png"),
                width: 100,
                height: 100,
                color: null,
                fit: BoxFit.fitHeight,
                alignment: Alignment.center,
              )),
          Positioned(
              width: 100,
              top: 328,
              left: 220,
              child: new Image(
                image: new AssetImage("assets/high.png"),
                width: 100,
                height: 180,
                color: null,
                fit: BoxFit.fitHeight,
                alignment: Alignment.center,
              )),
          Positioned(
              width: 300,
              height: 55,
              bottom: 200,
              left: 60,
              child: new SignInButton(
                Buttons.Google,
                text: "Sign in with Google",
                onPressed: () {
                  _authenticationBloc.dispatch(
                    SignInWithGoogle(),
                  );
                }, //on press
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)),
              )),
          Positioned(
              width: 300,
              height: 55,
              bottom: 100,
              left: 60,
              child: new SignInButton(
                Buttons.Facebook,
                text: "Sign in with FaceBook",
                onPressed: () {
                  BlocProvider.of<AuthenticateBloc>(context).dispatch(
                    SignInWithGoogle(),
                  );
                }, //on press
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)),
              ))
        ]));
  }
}
// BlocProvider(
//         bloc: _authenticationBloc,
//         child: new Stack(children: [
//           new Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage(
//                     "assets/pngtree-purple-brilliant-background-image_257402.jpg"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Positioned(
//               width: 100,
//               top: 350,
//               left: 140,
//               child: new Image(
//                 image: new AssetImage("assets/love-icon.png"),
//                 width: 100,
//                 height: 100,
//                 color: null,
//                 fit: BoxFit.fitHeight,
//                 alignment: Alignment.center,
//               )),
//           Positioned(
//               width: 100,
//               top: 328,
//               left: 220,
//               child: new Image(
//                 image: new AssetImage("assets/high.png"),
//                 width: 100,
//                 height: 180,
//                 color: null,
//                 fit: BoxFit.fitHeight,
//                 alignment: Alignment.center,
//               )),
//           Positioned(
//               width: 300,
//               height: 55,
//               bottom: 200,
//               left: 60,
//               child: new SignInButton(
//                 Buttons.Google,
//                 text: "Sign in with Google",
//                 onPressed: () {
//                   BlocProvider.of<AuthenticateBloc>(context)
//                       .dispatch(SignInWithGoogle().the).;
//                 }, //on press
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(0)),
//               )),
//           Positioned(
//               width: 300,
//               height: 55,
//               bottom: 100,
//               left: 60,
//               child: new SignInButton(
//                 Buttons.Facebook,
//                 text: "Sign in with FaceBook",
//                 onPressed: () {
//                   BlocProvider.of<AuthenticateBloc>(context)
//                       .dispatch(SignInWithGoogle());
//                 }, //on press
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(0)),
//               ))
//         ]));
//   }
