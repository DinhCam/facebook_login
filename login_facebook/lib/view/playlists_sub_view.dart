import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginfacebook/bloc/authentication_bloc.dart';
import 'package:loginfacebook/bloc/playlist_bloc.dart';
import 'package:loginfacebook/bloc/playlists_bloc.dart';
import 'package:loginfacebook/bloc/stores_bloc.dart';
import 'package:loginfacebook/events/authentication_event.dart';
import 'package:loginfacebook/events/playlists_event.dart';
import 'package:loginfacebook/model/media.dart';
import 'package:loginfacebook/model/playlist.dart';
import 'package:loginfacebook/model/store.dart';
import 'package:loginfacebook/repository/account_repository.dart';
import 'package:loginfacebook/repository/brand_repository.dart';
import 'package:loginfacebook/repository/playlist_repository.dart';
import 'package:loginfacebook/repository/stores_repository.dart';
import 'package:loginfacebook/states/home_page_state.dart';
import 'package:loginfacebook/states/playlists_state.dart';
import 'package:loginfacebook/states/stores_state.dart';
import 'package:loginfacebook/view/home_view.dart';
import 'package:loginfacebook/view/media_view.dart';
import 'package:loginfacebook/view/search_playlist_widget.dart';
import 'package:loginfacebook/view/sign_in_view.dart';

class PlaylistPage extends StatelessWidget {
  List<Playlist> playlists;
  PlaylistPage({Key key, @required this.playlists}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Audio Streaming',
      theme: new ThemeData(
          brightness: Brightness.dark,
          primaryColorBrightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.transparent,
          canvasColor: Colors.black54),
      home: new PlaylistsView(playlists: playlists),
    );
  }
}

class PlaylistsView extends StatefulWidget {
  List<Playlist> playlists;
  PlaylistsView({Key key, @required this.playlists}) : super(key: key);
  @override
  @override
  _PlaylistsViewState createState() => _PlaylistsViewState();
}

class _PlaylistsViewState extends State<PlaylistsView> {
  HomePageBloc _homePageBloc;
  PlaylistsBloc _playlistsbloc;
  AuthenticateBloc _authenticateBloc;
  int currentIndex = 1;
  StoresBloc _storesBloc;
  @override
  void initState() {
    super.initState();
    _homePageBloc = HomePageBloc(playlistRepository: PlaylistRepository());
    _storesBloc = StoresBloc(storesRepository: StoresRepository());
    _playlistsbloc = PlaylistsBloc(brandRepository: BrandRepository());
    _authenticateBloc = AuthenticateBloc(accountRepository: AccountRepository());
    _playlistsbloc.add(LoadPlaylistsSubDetail(playlists: widget.playlists));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener(
            bloc: _homePageBloc,
            listener: (BuildContext context, HomePageState state) {
              if (state is OnPushState) {
                Navigator.pop(context);

                Navigator.pop(context);
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
      child: new WillPopScope(
        onWillPop: () async {
          return true;
        },
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
                  title: Text("Playlists"),
                  leading: new IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          showSearch(context: context, delegate: DataSearch());
                        })
                  ],
                  backgroundColor: Colors.black26),
              backgroundColor: Colors.transparent,
              body: new SafeArea(
                  child: new ListView(children: <Widget>[
                new Container(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(children: <Widget>[
                      StreamBuilder<List<Playlist>>(
                        stream: _playlistsbloc.stream_playists,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          return snapshot.hasData
                              ? PlaylistsListViewVertical(
                                  playlistsview: snapshot.data)
                              : Center(child: CircularProgressIndicator());
                        },
                      )
                    ]))
              ])))
        ]),
      ),
    );
  }
  Drawer _appDrawer() {
    return new Drawer(
        child: new SafeArea(
      child: Column(
        children: <Widget>[
          new Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.10,
              color: Colors.black87,
              margin: const EdgeInsets.only(top: 3),
              alignment: Alignment.topCenter,
              child: new OutlineButton(
                  splashColor: Colors.grey,
                  onPressed: () {
                    _authenticateBloc.add(LoggedOut());
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
                    Image(
                        image: AssetImage("assets/export.png"),
                        width: 60.0,
                        height: 60.0,
                        fit: BoxFit.fitHeight),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ])))
        ],
      ),
    ));
  }
}



class PlaylistsListViewVertical extends StatelessWidget {
  PlaylistsBloc _playlistsbloc =
      PlaylistsBloc(brandRepository: BrandRepository());
  List<Playlist> playlistsview;
  PlaylistsListViewVertical({Key key, this.playlistsview}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener(
              bloc: _playlistsbloc,
              listener: (BuildContext context, PlaylistState state) {},
              child: null),
        ],
        child: new Container(
            margin: const EdgeInsets.all(5),
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                itemCount: playlistsview.length,
                itemBuilder: (BuildContext ctxt, int Index) {
                  return new Container(
                      width: MediaQuery.of(context).size.width,
                      // height: MediaQuery.of(context).size.width * 0.35,
                      decoration: _boxDecoration(Index),
                      margin: const EdgeInsets.only(top: 10),
                      alignment: Alignment.topCenter,
                      child: new RaisedButton(
                          color: Colors.transparent,
                          splashColor: Colors.lightBlue[90],
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MediaView(
                                      playlist: playlistsview[Index], page: 3,)),
                            );
                          },
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Image(
                                    image: NetworkImage(
                                        playlistsview[Index].ImageUrl),
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: MediaQuery.of(context).size.width *
                                        0.30,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                          child: Text(
                                            playlistsview[Index].PlaylistName,
                                            style: TextStyle(
                                              fontSize: 23,
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.clip,
                                          ),
                                      ),
                                      Container(
                                        alignment: Alignment.bottomLeft,
                                        child: _getTextWidgets(
                                            playlistsview[Index].media),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(bottom: 2),
                                        child: Center(
                                          child: Text(
                                            playlistsview[Index].media.length > 0?
                                            '\nShow more music':'\nNo music was added',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ])));
                })));
  }

  Widget _getTextWidgets(List<Media> medias) {
    List<Widget> list = new List<Widget>();
    String data ='';
    for (var i = 0; i < medias.length; i++) {
        data +=(i + 1).toString() + '. ' + medias[i].MusicName+'\n';
    }
    list.add(   
           new Container(
          alignment: Alignment.bottomLeft,
          child:Text(data,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
          overflow: TextOverflow.clip,
          textAlign: TextAlign.left,
        ),
        ),);
    return new Column(children: list);
  }

  BoxDecoration _boxDecoration(int index) {
    int them = (index % 4);
    if (them == 0) {
      return new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
      
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black,
              Colors.blueGrey,
              Colors.black,
            ],
          ));
    } else if (them == 1) {
      return new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              Colors.black,
              Colors.purple,
              Colors.black,
            ],
          ));
    } else if (them == 2) {
      return new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              Colors.black,
              Colors.indigo,
              Colors.black,
            ],
          ));
    } else if (them == 3) {
      return new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),

          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black,
              Colors.cyan,
              Colors.black,
            ],
          ));
    }
  }
}
