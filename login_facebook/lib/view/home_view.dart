
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loginfacebook/bloc/authentication_bloc.dart';
import 'package:loginfacebook/bloc/authentication_event.dart';
import 'package:loginfacebook/bloc/playlist_bloc.dart';
import 'package:loginfacebook/model/playlist.dart';
import 'package:loginfacebook/repository/account_repository.dart';
import 'package:loginfacebook/repository/playlist_repository.dart';
import 'package:loginfacebook/view/sign_in_view.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Audio Streaming',
      theme: new ThemeData(
        brightness: Brightness.dark,
        primaryColorBrightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.transparent,
        canvasColor : Colors.black54

      ),
      home: new HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PlaylistBloc _playlistBloc;
  AuthenticateBloc _authenticateBloc;
  int pageNumber = 1;
  @override
  void initState() {
    super.initState();
    _authenticateBloc =
        AuthenticateBloc(accountRepository: AccountRepository());
    _playlistBloc = PlaylistBloc(playlistRepository: PlaylistRepository());
    _playlistBloc.getTop3Playlist();
    _playlistBloc.getUserFavoritesPlaylist();
    _playlistBloc.getPlaylistWithPage(pageNumber);
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
                alignment: Alignment.center,
                width: 90,
                height: 80,
                child: new Text(
                  "Home",
                  style: new TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              new Container(
                  width: MediaQuery.of(context).size.width - 90 - 70,
                  height: 80,
                  child: new SearchBar(
                    onSearch: search,
                    onItemFound: (Post post, int index) {
                      return ListTile(
                        title: Text(post.title),
                        subtitle: Text(post.description),
                      );
                    },
                    hintText: "Search",
                    searchBarStyle: SearchBarStyle(
                      backgroundColor: Colors.white10,
                    ),
                  )),
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
                    stream: _playlistBloc.stream_favotite,
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
                    stream: _playlistBloc.stream_top3,
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
                new Row(
                  children: <Widget>[
                    new Container(
                        margin: const EdgeInsets.only(right: 30),
                        width: 100,
                        color: Colors.blue,
                        child: new Row(
                          children: <Widget>[
                            if (pageNumber > 0)
                              (new Container(
                                  alignment: Alignment.topLeft,
                                  child: new OutlineButton(
                                      onPressed: () {
                                        pageNumber--;
                                        _playlistBloc
                                            .getPlaylistWithPage(pageNumber);
                                      },
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                      child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 0),
                                          child: new Text("Previuos"))))),
                          ],
                        )),
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
                    new Container(
                        margin: const EdgeInsets.only(left: 30),
                        alignment: Alignment.topRight,
                        width: 100,
                        color: Colors.blue,
                        child: new Row(
                          children: <Widget>[
                            new Container(
                                  padding: const EdgeInsets.only(left: 00.0),
                                  alignment: Alignment.topLeft,
                                  child: new OutlineButton(
                                      onPressed: () {
                                        pageNumber++;
                                        _playlistBloc
                                            .getPlaylistWithPage(pageNumber);
                                      },
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                      child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 0),
                                          child: new Text("Next")))),
                          ],
                        )),
                  ],
                ),
                StreamBuilder<List<Playlist>>(
                  stream: _playlistBloc.stream_playlistWIthPage,
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
                      onPressed: () {},
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

