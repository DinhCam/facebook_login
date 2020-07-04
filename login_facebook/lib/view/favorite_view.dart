import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginfacebook/bloc/playlist_bloc.dart';
import 'package:loginfacebook/bloc/playlist_in_store_bloc.dart';
import 'package:loginfacebook/bloc/stores_bloc.dart';
import 'package:loginfacebook/bloc/time_submit_bloc.dart';
import 'package:loginfacebook/events/home_page_event.dart';
import 'package:loginfacebook/events/playlist_in_store_event.dart';
import 'package:loginfacebook/events/time_submit_event.dart';
import 'package:loginfacebook/model/playlist.dart';
import 'package:loginfacebook/network_provider/authentication_network_provider.dart';
import 'package:loginfacebook/repository/current_media_repository.dart';
import 'package:loginfacebook/repository/playlist_in_store_repository.dart';
import 'package:loginfacebook/repository/playlist_repository.dart';
import 'package:loginfacebook/repository/time_submit_repository.dart';
import 'package:loginfacebook/states/playlist_in_store_state.dart';
import 'package:loginfacebook/states/time_submit_state.dart';
import 'package:loginfacebook/view/playlist_in_store_view.dart';

import 'home_view.dart';

class FavoriteView extends StatelessWidget {
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
      home: new FavoritePage(),
    );
  }
}

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  HomePageBloc _homePageBloc;
  PlaylistInStoreBloc _playlistInStoreBloc;
  TimeSubmitBloc _timeSubmitBloc;
  List<Playlist> listFavorite;
  bool isSubmit = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _homePageBloc = HomePageBloc(playlistRepository: PlaylistRepository());
    _timeSubmitBloc = TimeSubmitBloc(repository: TimeSubmitRepository());
    
    _playlistInStoreBloc = PlaylistInStoreBloc(
        currentMediaRepo: CurrentMediaRepository(),
        playlistInStoreRepo: PlaylistInStoreRepository());

    
    _homePageBloc.add(GetFavorite());
    _timeSubmitBloc.add(PageCreateTimeSubmit());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener(
          bloc: _playlistInStoreBloc,
          listener: (BuildContext context, PlaylistInStoreState state) {
            if (state is SubmitSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => FavoriteView()),
              );
            }
            if (state is SubmitWrongBrand) {
              return showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: ListTile(
                    title: Text("Submit fail"),
                    subtitle: Text(state.error),
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
            if (state is SubmitFail) {}
          },
          child: new Container(),
        ),
      ],
      child: WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.transparent,
          appBar: new AppBar(
              title: new Text("Favorite Playlist"),
              leading: new IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlaylistInStoreStateless()),
                  );
                },
              ),
              backgroundColor: Colors.black26),
          body: new Column(
            children: <Widget>[
              StreamBuilder<String>(
                stream: _timeSubmitBloc.controller_stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return buildStatusSubmit(
                        snapshot.data, _playlistInStoreBloc, listFavorite,context);
                  } else if (snapshot.hasError) {
                    return Container();
                  }
                  return Container();
                },
              ),
              StreamBuilder(
                stream: _homePageBloc.stream_favotite,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    listFavorite = snapshot.data;
                    return buildList(snapshot.data);
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
              
            ],
          ),
        ),
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PlaylistInStoreStateless()),
          );
          return true;
        },
      ),
    );
  }
}

Widget buildStatusSubmit(String snapshot, bloc, list,context) {
  if (snapshot == "CanSubmit") {
    return FlatButton(
        color: Colors.blue,
        textColor: Colors.white,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        padding: EdgeInsets.all(8.0),
        splashColor: Colors.blueAccent,
      child: new Text("Submit", style: TextStyle(color: Colors.white),),
      onPressed: (){
        showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: ListTile(
                    title: Text("Submit Success"),
                    subtitle: Text("ssss"),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              );
        bloc.add(SubmitfavoritePlaylist(user: currentUserWithToken, list: list, storeID: checkedInStore.Id));
      },
    );
  }else{
    return new Text("You can submit after: "+snapshot+" minutes.");
  }
}

Widget buildList(List<Playlist> snapshot) {
  return Expanded(
    child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: snapshot.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              // height: MediaQuery.of(context).size.height * 0.2,
              decoration: new BoxDecoration(
                  border:
                      Border(bottom: BorderSide(width: 1, color: Colors.black)),
                  color: Color.fromARGB(255, 255, 255, 255)),
              child: new ListTile(
                title: new Text(
                    (index + 1).toString() +
                        ". " +
                        snapshot[index].PlaylistName,
                    style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                subtitle: new Text(
                  "asdsad",
                  style: TextStyle(color: Colors.black),
                ),
                leading: SizedBox(
                  height: 300.0,
                  width: 100.0, // fixed width and height
                  child: new Image(
                    image: NetworkImage(snapshot[index].ImageUrl),
                    height: 500,
                    width: 150,
                    fit: BoxFit.fill,
                  ),
                ),
                // leading: currentPlay(listCurrentMedia, widget.playlist.Id,
                //     listMedia[index].Id),
                trailing: new Text(
                  snapshot[index].BrandName,
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ));
        }),
  );
}
