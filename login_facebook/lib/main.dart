import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoggedIn = false;
  String _message;
  final _auth = FirebaseAuth.instance;
  final _facebooklogin = FacebookLogin();

  Future _loginWithFacebook() async {
    // Gọi hàm LogIn() với giá trị truyền vào là một mảng permission
    // Ở đây mình truyền vào cho nó quền xem email
    //_facebooklogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
//    _facebooklogin.loginBehavior = FacebookLoginBehavior.nativeOnly;
    final result = await _facebooklogin.logIn(['email']);
    // Kiểm tra nếu login thành công thì thực hiện login Firebase
    // (theo mình thì cách này đơn giản hơn là dùng đường dẫn
    // hơn nữa cũng đồng bộ với hệ sinh thái Firebase, tích hợp được
    // nhiều loại Auth

    if (result.status == FacebookLoginStatus.loggedIn) {
      final credential = FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token,
      );
      // Lấy thông tin User qua credential có giá trị token đã đăng nhập
      final user = (await _auth.signInWithCredential(credential)).user;
      setState(() {
        _message = "Logged in as ${user.displayName}";
        _isLoggedIn = true;
      });
    }
  }

  Future _logout() async {
    // SignOut khỏi Firebase Auth
    await _auth.signOut();
    // Logout facebook
    await _facebooklogin.logOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  Future _checkLogin() async {
    // Kiểm tra xem user đã đăng nhập hay chưa
    final user = await _auth.currentUser();
    if (user != null) {
      setState(() {
        _message = "Logged in as ${user.displayName}";
        _isLoggedIn = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoggedIn
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_message),
            SizedBox(height: 12.0),
            OutlineButton(
              onPressed: () {
                _logout();
              },
              child: Text('Logout'),
            ),
          ],
        )
            : RaisedButton(
          onPressed: () {
            _loginWithFacebook();
          },
          color: Colors.blue,
          textColor: Colors.white,
          child: Text('Login with Facebook'),
        ),
      ),
    );
  }
}