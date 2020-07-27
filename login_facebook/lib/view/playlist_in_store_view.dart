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
  var a =
      "https://www.google.com/imgres?imgurl=https%3A%2F%2Fimages.pexels.com%2Fphotos%2F443446%2Fpexels-photo-443446.jpeg%3Fauto%3Dcompress%26cs%3Dtinysrgb%26dpr%3D1%26w%3D500&imgrefurl=https%3A%2F%2Fwww.pexels.com%2Fsearch%2FHD%2520wallpaper%2F&tbnid=NfFRAw463w60xM&vet=12ahUKEwin3P-26LLqAhUNArcAHbJnAvUQMygBegUIARCnAQ..i&docid=vV2hSIyJej_roM&w=500&h=323&itg=1&q=imge%20hd&ved=2ahUKEwin3P-26LLqAhUNArcAHbJnAvUQMygBegUIARCnAQ";
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
                  child:new Container(
                      width: MediaQuery.of(context).size.width,
                      child: FadeInImage.assetNetwork(                      
                      placeholder: "alt/loading.gif",
                      image: checkedInStore.ImageURL,
                      fit: BoxFit.fitWidth,
                    ),
                    ) ,
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
                image: AssetImage("assets/icons8-video-playlist-96.png"),
                width: MediaQuery.of(context).size.width * 0.15,
                fit: BoxFit.cover,
              ),
              title: Text(
                'My Favorite',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image(
                image: AssetImage("assets/qr-code.png"),
                width: MediaQuery.of(context).size.width * 0.15,
                fit: BoxFit.cover,
              ),
              title: Text(
                'Check out',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
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

  void onTabped(int index) async {
    setState(() {
      currentIndex = index;
    });
    if (currentIndex == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FavoriteView()),
      );
    } else if (currentIndex == 1) {
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
                          builder: (context) =>
                              MediaPage(playlist: playlist, page: 2)),
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
        Icons.play_circle_outline,
        color: Colors.green,
        size: 40,
      );
    } else {
      return new Icon(
        Icons.play_circle_outline,
        color: Colors.white,
        size: 40,
      );
    }
  }

  setUpTimedFetch() async {
    int timeToCall = 1000000;
    var rs=await getCurrentMedia();
    if (listCurrentMedia != null) {
      if(!listCurrentMedia.isEmpty){
        var now=new DateTime.now();
        var checkTime=listCurrentMedia[0].timeEnd.difference(now);
        if(checkTime.inMilliseconds>0){
          timeToCall=checkTime.inMilliseconds;
        }
      }      
    }
    print(timeToCall);
    timerCallApi =
        Timer.periodic(Duration(milliseconds: timeToCall), (timerCallApi) {
      setState(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PlaylistInStoreStateless()),
        );
      });
    });
  }

  Future<String> getCurrentMedia() async {
    CurrentMediaRepository repo = CurrentMediaRepository();
    final rs = await repo.getCurrentMediabyStoreId(checkedInStore.Id);
    listCurrentMedia = rs;
    return "success";
  }
}
