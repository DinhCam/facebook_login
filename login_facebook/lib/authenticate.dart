import 'dart:collection';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'main.dart';
import 'playlist.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
//final _facebooklogin = FacebookLogin();

String name;
String email;
String imageUrl;
String phoneNumber;
Authenticate currentUserWithToken;

bool _isLoggedIn = false;
String _message;
  
final _facebooklogin = FacebookLogin();

Future<bool> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    // Checking if email and name is null
     assert(user.email != null);
    // assert(user.displayName != null);
    // assert(user.photoUrl != null);
    if(user.email == null){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LaunchScreen()),
      );
    }else{

      name = user.displayName;
      phoneNumber = user.phoneNumber;
      
      email = user.email;
      imageUrl = user.photoUrl;

      currentUserWithToken  = await fetchUser(user.email);

      // Only taking the first part of the name, i.e., First Name
      if (name.contains(" ")) {
        name = name.substring(0, name.indexOf(" "));
      }

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      return true;
    }
}

void signOutGoogle() async {
  await _auth.signOut();
  await googleSignIn.signOut();
//  await _facebooklogin.logOut();

  print("User Sign Out");
}

// Future signInWithFacebook(BuildContext context) async {

//     final result = await _facebooklogin.logIn(['email']);

//     if (result.status == FacebookLoginStatus.loggedIn) {
//       final credential = FacebookAuthProvider.getCredential(
//         accessToken: result.accessToken.token,
//       );
//       // Lấy thông tin User qua credential có giá trị token đã đăng nhập
//       final user = (await _auth.signInWithCredential(credential)).user;
//       if(user.email == null){
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => LaunchScreen()),
//       );
//     }else{

//       name = user.displayName;
//       phoneNumber = user.phoneNumber;
      
//       email = user.email;
//       imageUrl = user.photoUrl;

//       currentUserWithToken  = await fetchUser(user.email);

//       // Only taking the first part of the name, i.e., First Name
//       if (name.contains(" ")) {
//         name = name.substring(0, name.indexOf(" "));
//       }

//       assert(!user.isAnonymous);
//       assert(await user.getIdToken() != null);

//       final FirebaseUser currentUser = await _auth.currentUser();
//       assert(user.uid == currentUser.uid);
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => HomePage()),
//       );
//       return true;
//     }
//     }
//   }


Future<Authenticate> fetchUser(String email) async {
  String url = 'https://audiostreaming-dev-as.azurewebsites.net/api/Account/authenticate';
  String jsonString = '{"email": "'+email+'"}';

  final http.Response response = await http.post(url,headers:  {
        HttpHeaders.contentTypeHeader: 'application/json'
      }, body: jsonString  );
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    Authenticate rs =  Authenticate.fromJson(json.decode(response.body));
    return rs;
  } else {
    throw Exception('Failed to load album');
  }
}

Future loginWithFacebook(BuildContext context) async {
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
      // setState(() {
      //   _message = "Logged in as ${user.displayName}";
      //   _isLoggedIn = true;
      // });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  Future logout() async {
    // SignOut khỏi Firebase Auth
    await _auth.signOut();
    // Logout facebook
    await _facebooklogin.logOut();
    await googleSignIn.signOut();
    // setState(() {
    //   _isLoggedIn = false;
    // });
     _isLoggedIn = false;
  }

  Future _checkLogin() async {
    // Kiểm tra xem user đã đăng nhập hay chưa
    final user = await _auth.currentUser();
    if (user != null) {
      // setState(() {
      //   _message = "Logged in as ${user.displayName}";
      //   _isLoggedIn = true;
      // });
      _message = "Logged in as ${user.displayName}";
      _isLoggedIn = true;
    }
  }


class Authenticate
    {
        String Id ;
        String Username ;
        String FullName ;
        String PhoneNumber ;
        String Email ;
        int Role ;
        bool  IsDelete = false;
        bool IsVip ;
        String CreateDate;
        String ModifyDate ;
        String Token ;

        Authenticate(
          {
            this.Id,
            this.Username,
            this.FullName,
            this.PhoneNumber,
            this.Email,
            this.Role,
            this.IsDelete,
            this.IsVip,
            this.CreateDate,
            this.ModifyDate,
            this.Token
          }
          );
        factory Authenticate.fromJson(Map<String, dynamic> json) {
          return Authenticate(
            Id: json['userId'],
            Username: json['username'],
            FullName: json['fullName'],
            PhoneNumber: json['phoneNumber'],
            Email: json['email'],
            Role: json['role'],
            IsDelete: json['isDelete'],
            IsVip: json['isVip'],
            CreateDate: json['createDate'],
            ModifyDate: json['modifyDate'],
            Token: json['token'],
          );
        }
    }