import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:loginfacebook/model/account.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const []]) : super(props);
}

class Uninitialized extends AuthenticationState {
}

class Authenticated extends AuthenticationState {
  final UserAuthenticated userAuthenticated;

  Authenticated(this.userAuthenticated) : super([userAuthenticated]);

}

class Unauthenticated extends AuthenticationState {
}