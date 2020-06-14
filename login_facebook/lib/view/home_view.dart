import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loginfacebook/bloc/authentication_bloc.dart';
import 'package:loginfacebook/bloc/authentication_event.dart';
import 'package:loginfacebook/bloc/home_page_event.dart';
import 'package:loginfacebook/bloc/playlist_bloc.dart';
import 'package:loginfacebook/bloc/search_playlist_bloc.dart';
import 'package:loginfacebook/model/playlist.dart';
import 'package:loginfacebook/repository/account_repository.dart';
import 'package:loginfacebook/repository/playlist_repository.dart';
import 'package:loginfacebook/view/media_view.dart';
import 'package:loginfacebook/view/sign_in_view.dart';

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
  int pageNumber = 1;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    _authenticateBloc =
        AuthenticateBloc(accountRepository: AccountRepository());
    _homePageBloc = HomePageBloc(playlistRepository: PlaylistRepository());
    _homePageBloc.dispatch(PageCreate());

    _fcm.configure(
          onMessage: (Map<String, dynamic> message) async {
            print("onMessage: $message");
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                        content: ListTile(
                        title: Text(message['notification']['title']),
                        subtitle: Text(message['notification']['body']),
                        ),
                        actions: <Widget>[
                        FlatButton(
                            child: Text('Ok'),
                            onPressed: () => Navigator.of(context).pop(),
                        ),
                    ],
                ),
            );
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
    _homePageBloc = HomePageBloc(playlistRepository: PlaylistRepository());
    _homePageBloc.dispatch(PageCreate());
  }

  @override
  build(BuildContext context) {
    return new Stack(children: <Widget>[
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
            IconButton(icon: Icon(Icons.search), onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            })
          ],
          backgroundColor: Colors.black26
        ),
        backgroundColor: Colors.transparent,
        bottomNavigationBar: new BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            // BottomNavigationBa
            onTap: onTabTapped, // new
            currentIndex: currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Image(
                  image: AssetImage("assets/icons8-home-page-64.png"),
                  width: 40,
                  fit: BoxFit.cover,
                ),
                title: Text("Home",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              ),
              BottomNavigationBarItem(
                icon: Image(
                  image: AssetImage("assets/icons8-favorite-folder-64.png"),
                  width: 40,
                  fit: BoxFit.cover,
                ),
                title: Text("Favorite",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              ),
              BottomNavigationBarItem(
                icon: Image(
                  image: AssetImage("assets/qr-code.png"),
                  width: 40,
                  fit: BoxFit.cover,
                ),
                title: Text("Check in",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              ),
              BottomNavigationBarItem(
                icon: Image(
                  image: AssetImage("assets/userinfo.png"),
                  width: 40,
                  fit: BoxFit.cover,
                ),
                title: Text("Profile",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              )
            ]),
        body: new SafeArea(
            child: new ListView(children: <Widget>[
          Row(
            children: <Widget>[
            
              new Container(
                  width: 70,
                  height: 70,
                  child: new OutlineButton(
                      splashColor: Colors.grey,
                      onPressed: () {
                        _authenticateBloc.dispatch(LoggedOut());
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
                      borderSide: BorderSide(color: Colors.transparent),
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image(
                                    image: AssetImage("assets/export.png"),
                                    height: 35.0,
                                    fit: BoxFit.fitHeight),
                              ]))))
            ],
          ),
          new Container(
              padding: const EdgeInsets.only(top: 10.0),
              margin: const EdgeInsets.only(left: 0, right: 0, top: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topCenter,
                    //margin: const EdgeInsets.only(left: 30, right: 0, top: 90),
                    child: Text(
                      "Your favorite",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
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
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topCenter,
                    // margin: const EdgeInsets.only(left: 30, right: 0, top: 260),
                    child: Text(
                      "Top 3 Playlist",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
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
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(children: <Widget>[
                    new Container(
                      alignment: Alignment.topCenter,
                      // margin: const EdgeInsets.only(left: 30, right: 0, top: 260),
                      child: Text(
                        "Playlist",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
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
    ]);
  }


  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  int currentIndex = 0;

  Future<List<Post>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    return List.generate(search.length, (int index) {
      return Post(
        "Title : $search $index",
        "Description :$search $index",
      );
    });
  }
}

class Post {
  final String title;
  final String description;

  Post(this.title, this.description);
}

class ListViewHorizontal extends StatelessWidget {
  List<Playlist> playlistsview = new List();

  ListViewHorizontal({Key key, this.playlistsview}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 5),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: playlistsview.length,
            itemBuilder: (BuildContext ctxt, int Index) {
              return new Container(
                  child: new OutlineButton(
                      splashColor: Colors.grey,
                      onPressed: () {},
                      borderSide: BorderSide(color: Colors.transparent),
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image(
                                    image: NetworkImage(
                                        playlistsview[Index].ImageUrl),
                                    width: 110.0,
                                    height: 110,
                                    fit: BoxFit.fitHeight),
                              ]))));
            }));
  }
}

class ListViewVertical extends StatelessWidget {
  List<Playlist> playlistsview = new List();

  ListViewVertical({Key key, this.playlistsview}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.only(bottom: 10),
        alignment: Alignment.topCenter,
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MediaPage(playlist: playlistsview[Index])),
                        );
                      },
                      borderSide: BorderSide(color: Colors.black),
                      child: Row(children: <Widget>[
                        Image(
                            image: NetworkImage(playlistsview[Index].ImageUrl),
                            width: 60.0,
                            height: 60.0,
                            fit: BoxFit.fitHeight),
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

class DataSearch extends SearchDelegate<String> {
  SearchPlaylistBloc _searchPlaylistBloc = SearchPlaylistBloc(playlistRepository: PlaylistRepository());
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query="";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return  StreamBuilder<List<Playlist>>(
        stream: _searchPlaylistBloc.stream_playlistWIthPage,
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListViewVertical(playlistsview: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
   _searchPlaylistBloc.getPlaylistsBySearchkey(query);
    query.isEmpty?_searchPlaylistBloc.getPlaylistsBySearchkey(""):_searchPlaylistBloc.getPlaylistsBySearchkey(query);
    return  StreamBuilder<List<Playlist>>(
        stream: _searchPlaylistBloc.stream_playlistWIthPage,
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListViewVertical(playlistsview: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      );
    
  }
}
