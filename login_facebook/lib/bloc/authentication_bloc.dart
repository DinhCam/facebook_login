import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:loginfacebook/events/authentication_event.dart';
import 'package:loginfacebook/states/authentication_state.dart';
import 'package:loginfacebook/model/account.dart';
import 'package:loginfacebook/repository/account_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:wifi/wifi.dart';
import 'package:wifi_configuration/wifi_configuration.dart';

class AuthenticateBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AccountRepository accountRepository = AccountRepository();
  UserAuthenticated user;

  final _userStreamController = StreamController<UserAuthenticated>();
  
 

  StreamSink<UserAuthenticated> get user_sink => _userStreamController.sink;
// expose data from stream
  Stream<UserAuthenticated> get stream_user => _userStreamController.stream;

  AuthenticateBloc({@required AccountRepository accountRepository})
      : assert(accountRepository != null),
        accountRepository = accountRepository;

  @override
  AuthenticationState get initialState => Uninitialized();
  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is SignInWithGoogle) {
      yield* _mapSignInwithGoogleToState();
    } else if (event is LoggedInWithFacebook) {
      yield* _mapLoggedInWithFacebookToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }
  
  Stream<AuthenticationState> _mapAppStartedToState() async* {
    // WifiConnectionStatus connectionStatus = await WifiConfiguration.connectToWifi("DK", "1111999o", "com.audiostreaming.loginfacebook");
    try {
      final isSignedIn = await accountRepository.CheckLogin();
      if (isSignedIn == true){        
          user_sink.add(user);
          yield Authenticated(user);
      } else {
        Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInWithFacebookToState() async* {
    try {
      user = await accountRepository.LogInWithFacebook();
      if (user != null) {
        user_sink.add(user);
        yield Authenticated(user);
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapSignInwithGoogleToState() async* {
    try {
      user = await accountRepository.SignInWithGoogle();
      if (user != null) {       
        user_sink.add(user);
        yield Authenticated(user);
      }else Unauthenticated();
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    accountRepository.SignOut();
  }
  
}
