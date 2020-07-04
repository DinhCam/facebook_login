import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loginfacebook/bloc/playlist_in_store_bloc.dart';
import 'package:loginfacebook/bloc/stores_bloc.dart';
import 'package:loginfacebook/events/playlist_in_store_event.dart';
import 'package:loginfacebook/model/category_playlist.dart';
import 'package:loginfacebook/model/current_media.dart';
import 'package:loginfacebook/model/playlist.dart';
import 'package:loginfacebook/model/playlist_in_store.dart';
import 'package:loginfacebook/repository/current_media_repository.dart';
import 'package:loginfacebook/repository/playlist_in_store_repository.dart';

import 'home_view.dart';
import 'media_view.dart';
import 'favorite_view.dart';

class PlaylistInStoreStateless extends StatelessWidget {
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
      home: new PlaylistInStoreView(),
    );
  }
}

class PlaylistInStoreView extends StatefulWidget {
  @override
  _PlaylistInStoreState createState() => _PlaylistInStoreState();
}

class _PlaylistInStoreState extends State<PlaylistInStoreView> {
  PlaylistInStoreBloc _playlistInStoreBloc;
  List<PlaylistInStore> listPIS;
  List<CurrentMedia> listCurrentMedia;
  Timer timerCallApi;
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _playlistInStoreBloc = PlaylistInStoreBloc(
        playlistInStoreRepo: PlaylistInStoreRepository(),
        currentMediaRepo: CurrentMediaRepository());
    _playlistInStoreBloc.add(PageCreatePIS(store: checkedInStore));
    setUpTimedFetch();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (timerCallApi != null) {
      timerCallApi.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text("Playlist in store"),
        leading: new IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      body: new Column(children: <Widget>[
        new Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      "assets/pngtree-purple-brilliant-background-image_257402.jpg"),
                  fit: BoxFit.cover)),
          child: new Column(
            children: <Widget>[
              new Container(
                alignment: Alignment.topCenter,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: AssetImage(
                        "assets/pngtree-purple-brilliant-background-image_257402.jpg"),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              new Container(
                decoration: new BoxDecoration(
                    color: Color.fromARGB(100, 187, 171, 201)),
                padding: EdgeInsets.fromLTRB(32, 10, 30, 10),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      checkedInStore.StoreName,
                      style: TextStyle(fontSize: 26.0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        StreamBuilder(
          stream: _playlistInStoreBloc.pis_stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              listPIS = snapshot.data;
              return buildList(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabped,
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Image(
              image:  AssetImage("assets/icons8-video-playlist-96.png"),
              width: MediaQuery.of(context).size.width * 0.15,
              fit: BoxFit.cover,
            ),
            title: Text('Favorite Playlist',style: TextStyle(color: Colors.green, fontSize: 16),),
          ),
          BottomNavigationBarItem(
            icon: Image(
              image:  AssetImage("assets/qr-code.png"),
              width: MediaQuery.of(context).size.width * 0.15,
              fit: BoxFit.cover,
            ),
              
            title: Text('Check out', style: TextStyle(color: Colors.green, fontSize: 16),),
          ),
        ],
        // currentIndex: _selectedIndex,
        // selectedItemColor: Colors.amber[800],
        // onTap: _onItemTapped,
      ),
    ),
    onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        return true;
      },
    );
  }
  void onTabped(int index) async{
    setState(() {
      currentIndex = index;
    });
    if(currentIndex ==0){
       Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => FavoriteView()),
            );

    }else if( currentIndex ==1){
      checkedInStore = null;
       Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
    }
  }

  Widget buildList(snapshot) {
    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: listPIS.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration:
                    new BoxDecoration(color: Color.fromARGB(50, 187, 171, 201)),
                child: new ListTile(
                  title: new Text(
                      (index + 1).toString() +
                          ". " +
                          listPIS[index].playlistName,
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold)),
                  subtitle: getCategory(listPIS[index].listCategoryPlaylists),
                  leading: Icon(Icons.library_music),
                  trailing: currentPlay(listPIS[index]),
                  onTap: () {
                    Playlist playlist = new Playlist(
                      Id: listPIS[index].playlistId,
                      PlaylistName: listPIS[index].playlistName,
                      ImageUrl: listPIS[index].imageUrl,
                    );                   
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MediaPage(
                              playlist: playlist,                            
                              page: 2)),
                    );
                  },
                ));
          }),
    );
  }

  Text getCategory(List<CategoryPlaylist> listCategoryMedia) {
    String s = "#";
    listCategoryMedia.forEach((e) {
      s += e.listCategory[0].getName + " #";
    });
    String s1 = s.substring(0, s.length - 1);
    return Text(
      s1,
      style: TextStyle(fontSize: 12),
    );
  }

  Icon currentPlay(PlaylistInStore list) {
    if (list.playlistId == listCurrentMedia[0].playlistId) {
      return new Icon(
        Icons.play_arrow,
        color: Colors.red,
        size: 40,
      );
    } else {
      return new Icon(
        Icons.play_arrow,
        color: Colors.white,
        size: 40,
      );
    }
  }

  setUpTimedFetch() async {
    int timeToCall=10000;
    await getCurrentMedia();
    if (listCurrentMedia != null) {
      timeToCall = listCurrentMedia[0].timeToPlay.inMilliseconds;
    }
    print(timeToCall);
    timerCallApi =
        Timer.periodic(Duration(milliseconds: timeToCall), (timerCallApi) {
      print("call api");
      setState(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PlaylistInStoreStateless()),
        );
      });
    });
  }
  getCurrentMedia() async{
    CurrentMediaRepository repo=CurrentMediaRepository();
    final rs= await repo.getCurrentMediabyStoreId(checkedInStore.Id);
    listCurrentMedia=rs;
  }
}
