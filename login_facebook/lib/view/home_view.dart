import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loginfacebook/bloc/authentication_bloc.dart';
import 'package:loginfacebook/bloc/playlist_bloc.dart';
import 'package:loginfacebook/bloc/stores_bloc.dart';
import 'package:loginfacebook/events/stores_event.dart';
import 'package:loginfacebook/model/playlist.dart';
import 'package:loginfacebook/model/store.dart';
import 'package:loginfacebook/repository/account_repository.dart';
import 'package:loginfacebook/repository/playlist_repository.dart';
import 'package:loginfacebook/repository/stores_repository.dart';
import 'package:loginfacebook/states/authentication_state.dart';
import 'package:loginfacebook/states/home_page_state.dart';
import 'package:loginfacebook/states/stores_state.dart';
import 'package:loginfacebook/utility/utils.dart';
import 'package:loginfacebook/view/app_drawer.dart';
import 'package:loginfacebook/view/media_view.dart';
import 'package:loginfacebook/view/playlist_in_store_view.dart';
import 'package:loginfacebook/view/search_playlist_widget.dart';
import 'package:loginfacebook/events/home_page_event.dart';
import 'package:loginfacebook/view/brands_view.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Audio Streaming',
      theme: new ThemeData(
          brightness: Brightness.light,
          primaryColorBrightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.transparent,
          canvasColor: Colors.black54),
      home: new HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomePageBloc _homePageBloc;
  AuthenticateBloc _authenticateBloc;
  StoresBloc _storesBloc;
  int pageNumber = 0;
  int currentIndex = 0;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    _authenticateBloc =
        AuthenticateBloc(accountRepository: AccountRepository());
    _storesBloc = StoresBloc(storesRepository: StoresRepository());
    _homePageBloc = HomePageBloc(playlistRepository: PlaylistRepository());
    _homePageBloc.add(PageCreate());
    _storesBloc.add(StatusCheckIn());
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {     
        Utils.utilShowDialog(message['notification']['title'], message['notification']['body'], context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
  }

  @override
  build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener(
              bloc: _authenticateBloc,
              listener: (BuildContext context, AuthenticationState state) {},
              child: null),
          BlocListener(
              bloc: _homePageBloc,
              listener: (BuildContext context, HomePageState state) {
                if (state is ViewPlaylists) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BrandsView()),
                  );
                }
              },
              child: null),
          BlocListener(
              bloc: _storesBloc,
              listener: (BuildContext context, StoresState state) {
                if (state is QRScanSuccess) {
                  Store store = state.store;
                  String message='Welcome to: ' +store.StoreName +'\nAddress: ' +store.Address;
                  Utils.utilShowDialog("Check in result", message, context);
                }
                if (state is QRScanFail) {
                  String msg = state.messages;
                  Utils.utilShowDialog("Check in result", msg, context);
                }
              },
              child: null),
        ],
        child: new Stack(children: <Widget>[
          Image.asset(
            //background
            "assets/pngtree-purple-brilliant-background-image_257402.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          new Scaffold(
            appBar: AppBar(
                title: Text("Home"),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        showSearch(context: context, delegate: DataSearch());
                      }),
                ],
                backgroundColor: Colors.black26),
            drawer: appDrawer(context),
            backgroundColor: Colors.transparent,
            bottomNavigationBar: StreamBuilder(
              stream: _storesBloc.statusCheckIn_stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return statusForCheckin(snapshot.data);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
            body: new SafeArea(
                child: new ListView(children: <Widget>[
              new Container(
                 // padding: const EdgeInsets.only(top: 10.0),
                  margin: const EdgeInsets.only(left: 0, right: 0, top: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Color.fromARGB(100, 187, 171, 201),
                                
                        ),
                        padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.05,
                        
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Your favorite",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      StreamBuilder<List<Playlist>>(
                        stream: _homePageBloc.stream_favotite,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          return snapshot.hasData
                              ? ListViewHorizontal(playlistsview: snapshot.data)
                              : Center(child: CircularProgressIndicator());
                        },
                      )
                    ],
                  )),
              new Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Color.fromARGB(100, 187, 171, 201),
                                
                        ),
                        padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.05,
                        
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Top 3 Playlist",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      StreamBuilder<List<Playlist>>(
                        stream: _homePageBloc.stream_top3,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          return snapshot.hasData
                              ? ListViewHorizontal(playlistsview: snapshot.data)
                              : Center(child: CircularProgressIndicator());
                        },
                      )
                    ],
                  )),
              new Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Column(children: <Widget>[
                    new Container(
                      decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Color.fromARGB(100, 187, 171, 201),
                                
                        ),
                        padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.05,
                        
                        alignment: Alignment.centerLeft,
                      child: Text(
                        "Playlist",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    StreamBuilder<List<Playlist>>(
                      stream: _homePageBloc.stream_playlistWIthPage,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) print(snapshot.error);
                        return snapshot.hasData
                            ? ListViewVertical(playlistsview: snapshot.data)
                            : Center(child: CircularProgressIndicator());
                      },
                    )
                  ]))
            ])),
          ),
        ]));
  }

  Widget statusForCheckin(snapshot) {
    return new BottomNavigationBar(
        // BottomNavigationBa
        onTap: onTabTapped, // new
        currentIndex: currentIndex,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage("assets/icons8-home-page-64.png"),
              width: MediaQuery.of(context).size.width * 0.10,
              fit: BoxFit.cover,
            ),
            title: Text("Home",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage("assets/icons8-video-playlist-64.png"),
              width: MediaQuery.of(context).size.width * 0.10,
              fit: BoxFit.cover,
            ),
            title: Text("Playlists",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          BottomNavigationBarItem(
            icon: Image(
              image: snapshot
                  ? AssetImage("assets/icons8-play-button-circled-96.png")
                  : AssetImage("assets/qr-code.png"),
              width: MediaQuery.of(context).size.width * 0.10,
              fit: BoxFit.cover,
            ),
            title: Text(snapshot ? "Current" : "Check in",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage("assets/userinfo.png"),
              width: MediaQuery.of(context).size.width * 0.10,
              fit: BoxFit.cover,
            ),
            title: Text("Profile",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          )
        ]);
  }

  void onTabTapped(int index) async {
    setState(() {
      currentIndex = index;
    });
    if (currentIndex == 2 && checkedInStore == null) {
      await _storesBloc.add(QRCodeScan());
    } else if (currentIndex == 2 && checkedInStore != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PlaylistInStoreStateless()),
      );
    } else if (currentIndex == 1) {
      _homePageBloc.add(ViewPlaylist());
    } else if (currentIndex == 0) {
      _homePageBloc.add(PageCreate());
    }
    currentIndex = 0;
  }
}

class ListViewHorizontal extends StatelessWidget {
  List<Playlist> playlistsview;
  ListViewHorizontal({Key key, this.playlistsview}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    HomePageBloc homePageBloc =
        HomePageBloc(playlistRepository: PlaylistRepository());
    if(playlistsview.isEmpty){
      return Container();
    }
    return Container(
        height: MediaQuery.of(context).size.width * 0.4,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 5),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: playlistsview.length,
            itemBuilder: (BuildContext ctxt, int Index) {
              return new Container(
                  decoration: _boxDecoration(Index),
                  margin: const EdgeInsets.only(right: 5),
                  child: new OutlineButton(
                      splashColor: Colors.grey,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MediaView(
                                    playlist: playlistsview[Index],
                                    page: 1,
                                  )),
                        );
                      },
                      borderSide: BorderSide(color: Colors.transparent),
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Image(
                            //     image:
                            //         NetworkImage(playlistsview[Index].ImageUrl),
                            //     width: MediaQuery.of(context).size.width * 0.50,
                            //     height:
                            //         MediaQuery.of(context).size.width * 0.29,
                            //     fit: BoxFit.cover),
                            FadeInImage.assetNetwork(
                              placeholder: "alt/loading.gif",
                              image: playlistsview[Index].ImageUrl,
                              width: MediaQuery.of(context).size.width * 0.50,
                                height:
                                    MediaQuery.of(context).size.width * 0.29,
                                fit: BoxFit.cover,                                
                            ),
                            Text(playlistsview[Index].PlaylistName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ))
                          ])));
            }));
  }

  BoxDecoration _boxDecoration(int index) {
    int them = (index % 4);
    if (them == 0) {
      return new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.centerLeft,
            colors: [
              Hexcolor("#818279"),
              Hexcolor("#818279"),
            ],
          ));
    } else if (them == 1) {
      return new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.bottomCenter,
            colors: [
              Hexcolor("#737994"),
              Hexcolor("#737994"),
            ],
          ));
    } else if (them == 2) {
      return new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.centerLeft,
            colors: [
              Colors.blueGrey,
              Colors.blueGrey,
            ],
          ));
    } else if (them == 3) {
      return new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.bottomCenter,
            colors: [
              Hexcolor("#25664c"),
              Hexcolor("#25664c"),
            ],
          ));
    }
  }
}

class ListViewVertical extends StatelessWidget {
  List<Playlist> playlistsview;
  ListViewVertical({Key key, this.playlistsview}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.only(bottom: 10),
        alignment: Alignment.topCenter,
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
            itemCount: playlistsview.length,
            itemBuilder: (BuildContext ctxt, int Index) {
              return new Container(
                  width: 400,
                  height: 60,
                  color: Colors.black87,
                  margin: const EdgeInsets.only(top: 3),
                  alignment: Alignment.topCenter,
                  child: new OutlineButton(
                      splashColor: Colors.grey,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MediaView(
                                  playlist: playlistsview[Index],                                 
                                  page: 1)),
                        );
                      },
                      borderSide: BorderSide(color: Colors.black),
                      child: Row(children: <Widget>[
                        // Image(
                        //     image: NetworkImage(playlistsview[Index].ImageUrl),
                        //     width: 60.0,
                        //     height: 60.0,
                        //     fit: BoxFit.fitHeight),
                        FadeInImage.assetNetwork(
                          placeholder: "alt/loading.gif",
                          image: playlistsview[Index].ImageUrl,
                          width: MediaQuery.of(context).size.width * 0.10,
                            height:
                                MediaQuery.of(context).size.width * 0.10,
                            fit: BoxFit.cover
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            playlistsview[Index].PlaylistName,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ])));
            }));
  }
}
