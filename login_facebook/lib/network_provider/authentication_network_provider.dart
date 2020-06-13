import 'package:loginfacebook/model/account.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';



final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final _facebooklogin = FacebookLogin();
String name;
String email;
String imageUrl;
String phoneNumber;
UserAuthenticated currentUserWithToken ;


class AccountNetworkProvider{
  String baseUrl ='https://audiostreaming-dev-as.azurewebsites.net/api/Account/';
  
  Future<UserAuthenticated> fetchUser(String IdToken, String fcmToken) async {
  String authenticateUrl = baseUrl+ 'authenticate';
  final user = await _auth.currentUser();


  String jsonString = '{'
  +'"idToken": "'+IdToken+'",'
  +'"fcmToken": "'+fcmToken+'"'
+'}';
  final http.Response response = await http.post(authenticateUrl,headers:  {
        HttpHeaders.contentTypeHeader: 'application/json'
      }, body: jsonString  );
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    UserAuthenticated rs =  UserAuthenticated.fromJson(json.decode(response.body));
    return rs;
  } else {
    throw Exception('Failed to load user');
  }
}

 
  Future<UserAuthenticated> fetchUserByJWT() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("JwtToken");
  String authenticateUrl = baseUrl+ 'authenticate';
  final http.Response response = await http.get(authenticateUrl,headers:  {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ' + token
      });
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    UserAuthenticated rs =  UserAuthenticated.fromJson(json.decode(response.body));
    return rs;
  } else {
    throw Exception('Failed to load user');
  }
}
}

class FirebaseNetworkProvider{
  AccountNetworkProvider accountNetworkProvider =new  AccountNetworkProvider();  

Future<UserAuthenticated> signInWithGoogle() async {
  final prefs = await SharedPreferences.getInstance();
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;
  assert(user.email != null);
  if (user.email == null) {
    return null;
  } else {
    name = user.displayName;
    phoneNumber = user.phoneNumber;
    email = user.email;
    imageUrl = user.photoUrl;
    final tokenId =await user.getIdToken();
     final token = tokenId.token  ; 
    currentUserWithToken = await accountNetworkProvider.fetchUser(tokenId.token, "Fcm token");
    prefs.setString("JwtToken", currentUserWithToken.Token);
    if (name.contains(" ")) {
      name = name.substring(0, name.indexOf(" "));
    }
    final idtoken =await user.getIdToken();      
    print(token);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    return currentUserWithToken;
  }
}

Future<UserAuthenticated> loginWithFacebook() async {
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
    assert(user.email != null);
    if (user.email == null) {
      return null;
    } else {
      name = user.displayName;
      phoneNumber = user.phoneNumber;
      email = user.email;
      imageUrl = user.photoUrl;
      final tokenId =await user.getIdToken();
      currentUserWithToken = await accountNetworkProvider.fetchUser(tokenId.toString(), "Fcm token");
      if (name.contains(" ")) {
        name = name.substring(0, name.indexOf(" "));
      }
    }
    return currentUserWithToken;
  }

}
  Future logout() async {
    await _auth.signOut();
    await _facebooklogin.logOut();
    await googleSignIn.signOut();
  }

Future<bool> checkLogin() async {
    final user = await _auth.currentUser();
    if (user != null) {
      currentUserWithToken = await accountNetworkProvider.fetchUserByJWT();
      return true;
    }else 
    return false;
  }
}

