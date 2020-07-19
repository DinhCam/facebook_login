import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loginfacebook/bloc/authentication_bloc.dart';
import 'package:loginfacebook/bloc/playlist_bloc.dart';
import 'package:loginfacebook/bloc/playlists_bloc.dart';
import 'package:loginfacebook/bloc/stores_bloc.dart';
import 'package:loginfacebook/events/home_page_event.dart';
import 'package:loginfacebook/events/playlists_event.dart';
import 'package:loginfacebook/events/stores_event.dart';
import 'package:loginfacebook/model/brand.dart';
import 'package:loginfacebook/model/store.dart';
import 'package:loginfacebook/network_provider/brand_network_provider.dart';
import 'package:loginfacebook/repository/account_repository.dart';
import 'package:loginfacebook/repository/brand_repository.dart';
import 'package:loginfacebook/repository/playlist_repository.dart';
import 'package:loginfacebook/repository/stores_repository.dart';
import 'package:loginfacebook/states/home_page_state.dart';
import 'package:loginfacebook/states/playlists_state.dart';
import 'package:loginfacebook/states/stores_state.dart';
import 'package:loginfacebook/utility/utils.dart';
import 'package:loginfacebook/view/app_drawer.dart';
import 'package:loginfacebook/view/playlist_in_store_view.dart';
import 'package:loginfacebook/view/playlists_sub_view.dart';
import 'package:loginfacebook/view/search_playlist_widget.dart';

class BrandsPage extends StatelessWidget {
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
      home: new BrandsView(),
    );
  }
}

class BrandsView extends StatefulWidget {
  @override
  _BrandsViewState createState() => _BrandsViewState();
}

class _BrandsViewState extends State<BrandsView> {
  HomePageBloc _homePageBloc;
  AuthenticateBloc _authenticateBloc;
  PlaylistsBloc _playlistsbloc;
  int currentIndex = 1;
  StoresBloc _storesBloc;
  BrandNetWorkProvider _brandNetWorkProvider = BrandNetWorkProvider();

  @override
  void initState() {
    super.initState();
    _homePageBloc = HomePageBloc(playlistRepository: PlaylistRepository());
    _authenticateBloc =
        AuthenticateBloc(accountRepository: AccountRepository());
    _storesBloc = StoresBloc(storesRepository: StoresRepository());
    _playlistsbloc = PlaylistsBloc(brandRepository: BrandRepository());
    _homePageBloc.add(GetPlaylistSuggets());
    _playlistsbloc.add(Loading());
    _storesBloc.add(StatusCheckIn());

  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener(
            bloc: _playlistsbloc,
            listener: (BuildContext context, PlaylistState state) {
              if (state is ViewMoreBrandPlaylistsState) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          (PlaylistPage(playlists: state.playlists))),
                );
              }
            },
            child: null),
        BlocListener(
            bloc: _homePageBloc,
            listener: (BuildContext context, HomePageState state) {
              if (state is OnPushState) {
                Navigator.pop(context);
              }else if (state is CreateState){
                Navigator.pop(context);
              }
            },
            child: null),
        BlocListener(
            bloc: _storesBloc,
            listener: (BuildContext context, StoresState state) {
              if (state is QRScanSuccess) {
                Store store = state.store;
                // showDialog(
                //   context: context,
                //   builder: (context) => AlertDialog(
                //     content: ListTile(
                //       title: Text("Check in result"),
                //       subtitle: Text('Welcome to: ' +
                //           store.StoreName +
                //           '\nAddress: ' +
                //           store.Address),
                //     ),
                //     actions: <Widget>[
                //       FlatButton(
                //         child: Text('Ok'),
                //         onPressed: () => Navigator.of(context).pop(),
                //       ),
                //     ],
                //   ),
                // );
                String message='Welcome to: ' +store.StoreName +'\nAddress: ' +store.Address;
                Utils.utilShowDialog("Check in result", message, context);
              }
              if (state is QRScanFail) {
                String msg = state.messages;
                // showDialog(
                //   context: context,
                //   builder: (context) => AlertDialog(
                //     content: ListTile(
                //       title: Text("Check in result"),
                //       subtitle: Text(msg),
                //     ),
                //     actions: <Widget>[
                //       FlatButton(
                //         child: Text('Ok'),
                //         onPressed: () => Navigator.of(context).pop(),
                //       ),
                //     ],
                //   ),
                // );
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
                title: Text("Brands"),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        showSearch(context: context, delegate: DataSearch());
                      })
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
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(children: <Widget>[
                    StreamBuilder<List<Brand>>(
                      stream: _playlistsbloc.stream_brands,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) print(snapshot.error);
                        return snapshot.hasData
                            ? BransListViewVertical(brandsview: snapshot.data)
                            : Center(child: CircularProgressIndicator());
                      },
                    )
                  ])
                  )
            ]))
            )
      ]),
    );
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
      Navigator.push(
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

class BransListViewVertical extends StatelessWidget {
  PlaylistsBloc _playlistsbloc =
      PlaylistsBloc(brandRepository: BrandRepository());
  List<Brand> brandsview;
  BransListViewVertical({Key key, this.brandsview}) : super(key: key);
  String error;
  

  @override
  Widget build(BuildContext context) {
     
    return MultiBlocListener(
        listeners: [
          BlocListener(
              bloc: _playlistsbloc,
              listener: (BuildContext context, PlaylistState state) {
                if (state is ViewMoreBrandPlaylistsState) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            (PlaylistsView(playlists: state.playlists))),
                  );
                }
                if (state is LoadSubcribeTopicState){
                  loadStatusSubcribe(state.context,state.isSubcribe , state.brandName);
                }
                if (state is ChangeSuccess){    
                  Navigator.pop(state.context);            
                  loadStatusSubcribe(state.context,state.isSubcribe , state.brandName);
                }
                if (state is ChangeError){                
                  error=state.error;
                }
              },
              child: null),
        ],
        child: new Container(
            padding: const EdgeInsets.only(bottom: 10),
            margin: const EdgeInsets.all(5),
            alignment: Alignment.topCenter,
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                itemCount: brandsview.length,
                itemBuilder: (BuildContext ctxt, int Index) {
                  return new Container(
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      decoration: _boxDecoration(Index),
                      margin: const EdgeInsets.only(top: 3),
                      alignment: Alignment.topCenter,
                      child: new RaisedButton(
                          color: Colors.transparent,
                          splashColor: Colors.lightBlue,
                          onLongPress: () async{
                            _playlistsbloc.add(LoadSubcribeTopicEvent(channel: brandsview[Index].brandName, context: context));
                            
                            
                          },
                          onPressed: () {
                            if (brandsview[Index].playlists != null) {
                              _playlistsbloc.add(ViewMoreBrandPlaylists(
                                  playlists: brandsview[Index].playlists));
                            }
                          },
                          child: new Container(
                              color: Colors.transparent,
                              child: Center(
                                child: RichText(
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: brandsview[Index].brandName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                          color: Colors.white,
                                        )),
                                    brandsview[Index].playlists != null
                                        ? TextSpan(
                                            text: '\n' +
                                                brandsview[Index]
                                                    .playlists
                                                    .length
                                                    .toString() +
                                                ' playlist',
                                            style: TextStyle(
                                              fontSize: 15,
                                            ))
                                        : TextSpan(
                                            text: '\n' +
                                                'No playlist was created. Subscribe to get notify new playlist',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ]),
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.center,
                                ),
                              ))));
                })));
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
              Hexcolor("#000000"),
              Colors.lightBlue,
              Hexcolor("#000000"),
            ],
          ));
    } else if (them == 1) {
      return new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.bottomCenter,
            colors: [
              Hexcolor("#000000"),
              Hexcolor("#3c0275"),
              Hexcolor("#000000"),
            ],
          ));
    } else if (them == 2) {
      return new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.centerLeft,
            colors: [
              Hexcolor("#000000"),
              Hexcolor("#11265e"),
              Hexcolor("#1147d4"),
              Hexcolor("#11265e"),
              Hexcolor("#000000"),
            ],
          ));
    } else if (them == 3) {
      return new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.bottomCenter,
            colors: [
              Hexcolor("#000000"),
              Hexcolor("#25664c"),
              Hexcolor("#038f57"),
              Hexcolor("#25664c"),
              Hexcolor("#000000"),
            ],
          ));
    }
  }
 loadStatusSubcribe(context, snapshot, brandName) async{
    return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return new SafeArea(
          child: Container(
              width: 400,
              height: 60,
              color: Colors.black87,
              margin: const EdgeInsets.only(top: 3),
              alignment: Alignment.topCenter,
              child: Row(children: <Widget>[
                new Container(
                  width: MediaQuery.of(context)
                          .size
                          .width *
                      0.1,
                  child: Image(
                      image: AssetImage(
                          'assets/icons8-push-notifications-64.png'),
                      width: 60.0,
                      height: 60.0,
                      fit: BoxFit.fitHeight),
                ),
                new Container(
                    width: MediaQuery.of(context)
                            .size
                            .width *
                        0.7,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(
                              left: 5),
                      child: Text(
                        'Subcribe ' +
                            brandName +
                            '.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.clip,
                      ),
                    )),
                new Container(
                    width: MediaQuery.of(context)
                            .size
                            .width *
                        0.15,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(
                              right: 0),
                      child: new Switch(
                          onChanged: (value) {
                            _playlistsbloc.add(ChageStatusSubcribe(isSubcribe: snapshot, channel: brandName, context: context));
                            value=true;
                          },
                          value: snapshot)
                    )),
              ])));
    });
  }

  
}
