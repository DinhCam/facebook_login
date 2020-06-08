import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:loginfacebook/main.dart';
import 'playlist.dart';
import 'authenticate.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Audio Streaming',
      theme: new ThemeData(
        brightness: Brightness.dark,
        primaryColorBrightness: Brightness.dark,
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
  @override
  void initState() {
    super.initState();
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
            // BottomNavigationBa
            onTap: onTabTapped, // new
            currentIndex: currentIndex,
            backgroundColor: Colors.transparent,
            fixedColor: Colors.red[50],
            items: [
              BottomNavigationBarItem(
                icon: Image(
                  image: AssetImage("assets/icons8-favorite-folder-64.png"),
                  width: 60,
                  fit: BoxFit.cover,
                ),
                title: Text("Favorite",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              ),
              BottomNavigationBarItem(
                icon: Image(
                  image: AssetImage("assets/qr-code.png"),
                  width: 60,
                  fit: BoxFit.cover,
                ),
                title: Text("Check in",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              ),
              BottomNavigationBarItem(
                icon: Image(
                  image: AssetImage("assets/userinfo.png"),
                  width: 50,
                  fit: BoxFit.cover,
                ),
                title: Text("Profile",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              )
            ]),
        body: SafeArea(
            child: Row(
          children: <Widget>[
            new Container(
                width: 330,
                height: 80,
                margin: const EdgeInsets.only(
                  left: 10.0,
                ),
                child: new SearchBar<Post>(
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
                      logout();
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
                              return LaunchScreen();
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
        )),
      ),
      new Container(
          padding: const EdgeInsets.only(top :20.0),
          margin: const EdgeInsets.only(left: 0, right: 0, top: 10),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 30, right: 0, top: 90),
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
              FutureBuilder<List<Playlist>>(
                future: GetUserFavoritePlaylists(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? ListViewPosts(playlistsview: snapshot.data)
                      : Center(child: CircularProgressIndicator());
                },
              )
            ],
          )),
      new Container(
          padding: const EdgeInsets.only(top :20.0),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 30, right: 0, top: 260),
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
              FutureBuilder<List<Playlist>>(
                future: GetTop3Playlists(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? ListViewPosts(playlistsview: snapshot.data)
                      : Center(child: CircularProgressIndicator());
                },
              )
            ],
          )),
      new Container(
        padding: const EdgeInsets.only(top :20.0),
          child: Column(children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(left: 30, right: 0, top: 420),
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
            FutureBuilder<List<Playlist>>(
              future: Get10Playlists(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? ListViewVertical(playlistsview: snapshot.data)
                    : Center(child: CircularProgressIndicator());
              },
            )
          ]))
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
