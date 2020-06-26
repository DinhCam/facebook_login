import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginfacebook/bloc/authentication_bloc.dart';
import 'package:loginfacebook/bloc/playlist_bloc.dart';
import 'package:loginfacebook/bloc/stores_bloc.dart';
import 'package:loginfacebook/events/authentication_event.dart';
import 'package:loginfacebook/events/home_page_event.dart';
import 'package:loginfacebook/events/stores_event.dart';
import 'package:loginfacebook/model/store.dart';
import 'package:loginfacebook/repository/account_repository.dart';
import 'package:loginfacebook/repository/playlist_repository.dart';
import 'package:loginfacebook/repository/stores_repository.dart';
import 'package:loginfacebook/states/authentication_state.dart';
import 'package:loginfacebook/states/home_page_state.dart';
import 'package:loginfacebook/states/stores_state.dart';
import 'package:loginfacebook/view/brands_view.dart';
import 'package:loginfacebook/view/home_view.dart';
import 'package:loginfacebook/view/sign_in_view.dart';

Drawer appDrawer(BuildContext context) {
  AuthenticateBloc _authenticateBloc =
      AuthenticateBloc(accountRepository: AccountRepository());
  StoresBloc _storesBloc = StoresBloc(storesRepository: StoresRepository());
  HomePageBloc _homePageBloc =
      HomePageBloc(playlistRepository: PlaylistRepository());
  return new Drawer(
      child: MultiBlocListener(
          listeners: [
        BlocListener(
            bloc: _authenticateBloc,
            listener: (BuildContext context, AuthenticationState state) {},
            child: null),
        BlocListener(
            bloc: _homePageBloc,
            listener: (BuildContext context, HomePageState state) {
              if (state is ViewPlaylists) {
                Navigator.pop(context);
                Navigator.pop(context,
                    MaterialPageRoute(builder: (context) => BrandsView()));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BrandsView()),);
              }
            },
            child: null),
        BlocListener(
            bloc: _storesBloc,
            listener: (BuildContext context, StoresState state) {
              if (state is QRScanSuccess) {
                Store store = state.store;
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: ListTile(
                      title: Text("Check in result"),
                      subtitle: Text('Welcome to: ' +
                          store.StoreName +
                          '\nAddress: ' +
                          store.Address),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Ok'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                );
              }
              if (state is QRScanFail) {
                String msg = state.messages;
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: ListTile(
                      title: Text("Check in result"),
                      subtitle: Text(msg),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Ok'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                );
              }
            },
            child: null),
      ],
          child: new SafeArea(
            child: Column(
              children: <Widget>[
                new Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.white,
                    ),
                    margin: const EdgeInsets.only(top: 3, bottom: 4),
                    alignment: Alignment.topCenter,
                    child: new OutlineButton(
                        splashColor: Colors.grey,
                        onPressed: () {
                          _homePageBloc.add(PageCreate());
                        },
                        borderSide: BorderSide(color: Colors.black),
                        child: Row(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Image(
                                image: AssetImage(
                                    "assets/icons8-home-page-64.png"),
                                width:
                                    MediaQuery.of(context).size.width * 0.130,
                                height:
                                    MediaQuery.of(context).size.width * 0.130,
                                fit: BoxFit.fitHeight),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Home',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ]))),
                new Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.white,
                    ),
                    margin: const EdgeInsets.only(top: 3, bottom: 4),
                    alignment: Alignment.topCenter,
                    child: new OutlineButton(
                        splashColor: Colors.grey,
                        onPressed: () {
                          _homePageBloc.add(ViewPlaylist());
                        },
                        borderSide: BorderSide(color: Colors.black),
                        child: Row(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Image(
                                image: AssetImage(
                                    "assets/icons8-video-playlist-64.png"),
                                width:
                                    MediaQuery.of(context).size.width * 0.130,
                                height:
                                    MediaQuery.of(context).size.width * 0.130,
                                fit: BoxFit.fitHeight),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Playlists',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ]))),
                new Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.white,
                    ),
                    margin: const EdgeInsets.only(top: 3, bottom: 4),
                    alignment: Alignment.topCenter,
                    child: new OutlineButton(
                        splashColor: Colors.grey,
                        onPressed: () {
                          Navigator.pop(context);
                          _storesBloc.add(QRCodeScan());
                        },
                        borderSide: BorderSide(color: Colors.black),
                        child: Row(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Image(
                                image: AssetImage("assets/qr-code.png"),
                                width:
                                    MediaQuery.of(context).size.width * 0.130,
                                height:
                                    MediaQuery.of(context).size.width * 0.130,
                                fit: BoxFit.fitHeight),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Check in',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ]))),
                new Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.white,
                    ),
                    margin: const EdgeInsets.only(top: 3, bottom: 4),
                    alignment: Alignment.topCenter,
                    child: new OutlineButton(
                        splashColor: Colors.grey,
                        onPressed: () {},
                        borderSide: BorderSide(color: Colors.black),
                        child: Row(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Image(
                                image: AssetImage("assets/userinfo.png"),
                                width:
                                    MediaQuery.of(context).size.width * 0.130,
                                height:
                                    MediaQuery.of(context).size.width * 0.130,
                                fit: BoxFit.fitHeight),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Profile',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ]))),
                new Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.white,
                    ),
                    margin: const EdgeInsets.only(top: 3, bottom: 4),
                    alignment: Alignment.topCenter,
                    child: new OutlineButton(
                        splashColor: Colors.grey,
                        onPressed: () {
                          _authenticateBloc.add(LoggedOut());
                          Navigator.popUntil(context, (route) => true);
                          Navigator.of(context).pop(
                            MaterialPageRoute(
                              builder: (context) {
                                return HomeScreen();
                              },
                            ),
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return SignInScreen();
                              },
                            ),
                          );
                        },
                        borderSide: BorderSide(color: Colors.black),
                        child: Row(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Image(
                                image: AssetImage("assets/export.png"),
                                width:
                                    MediaQuery.of(context).size.width * 0.130,
                                height:
                                    MediaQuery.of(context).size.width * 0.130,
                                fit: BoxFit.fitHeight),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Sign Out',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ])))
              ],
            ),
          )));
}
