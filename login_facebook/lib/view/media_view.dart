import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loginfacebook/bloc/media_bloc.dart';
import 'package:loginfacebook/bloc/stores_bloc.dart';
import 'package:loginfacebook/events/media_event.dart';
import 'package:loginfacebook/model/category_media.dart';
import 'package:loginfacebook/model/current_media.dart';
import 'package:loginfacebook/model/media.dart';
import 'package:loginfacebook/model/playlist.dart';
import 'package:loginfacebook/network_provider/authentication_network_provider.dart';
import 'package:loginfacebook/repository/current_media_repository.dart';
import 'package:loginfacebook/repository/media_repository.dart';
import 'package:loginfacebook/view/playlist_in_store_view.dart';

import 'home_view.dart';

class MediaPage extends StatelessWidget {
  Playlist playlist;
  int page;
  MediaPage({Key key, @required this.playlist, @required this.page})
      : super(key: key);

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
      home: new MediaView(playlist: playlist, page: page),
    );
  }
}

class MediaView extends StatefulWidget {
  Playlist playlist;
  int page;
  MediaView({Key key, @required this.playlist, @required this.page})
      : super(key: key);
  @override
  _MediaViewState createState() => _MediaViewState();
}

class _MediaViewState extends State<MediaView> {
  MediaBloc _mediaBloc;
  List<Media> listMedia;
  Timer timerCallApi;
  List<CurrentMedia> listCurrentMedia;
  bool isPress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mediaBloc = MediaBloc(mediaRepository: MediaRepository());
    _mediaBloc.add(PageCreateMedia(playlist: widget.playlist));
    if(checkedInStore!=null){
      if (widget.page != 1) {
      setUpTimedFetch();
    }
    }
    
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
          // backgroundColor: Colors.blue[1000],
          resizeToAvoidBottomPadding: false,
          appBar: new AppBar(
              title: new Text(widget.playlist.PlaylistName),
              leading: new IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (widget.page == 1) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } else if (widget.page == 2) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlaylistInStoreStateless()),
                    );
                  } else if (widget.page == 3) {
                    Navigator.pop(context);
                  }
                },
              ),
              backgroundColor: Colors.black26),
          backgroundColor: Colors.transparent,
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
                    child: new Container(
                      width: MediaQuery.of(context).size.width,
                      child: FadeInImage.assetNetwork(
                        placeholder: "alt/loading.gif",
                        image: widget.playlist.ImageUrl,
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
                          widget.playlist.PlaylistName,
                          style: TextStyle(fontSize: 26.0),
                        ),
                        StreamBuilder(
                          stream: _mediaBloc.addPlaylist_stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return buildBt(snapshot.data);
                            } else if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            }
                            return Center(child: CircularProgressIndicator());
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            StreamBuilder(
              stream: _mediaBloc.media_stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  listMedia = snapshot.data;
                  return buildList(snapshot);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ])),
      onWillPop: () async {
        if (widget.page == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else if (widget.page == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PlaylistInStoreStateless()),
          );
        } else if (widget.page == 3) {
          Navigator.pop(context);
        }
        return true;
      },
    );
  }

  Widget buildList(snapshot) {
    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: listMedia.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: new BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.black)),
                    color: Color.fromARGB(255, 255, 255, 255)),
                child: new ListTile(
                  title: new Text(
                      (index + 1).toString() +
                          ". " +
                          listMedia[index].MusicName,
                      style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  subtitle: new Text(
                    "  singer: " +
                        listMedia[index].Singer +
                        " ,author: " +
                        listMedia[index].Author,
                    style: TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                  // leading: Icon(Icons.library_music),
                  leading: currentPlay(listCurrentMedia, widget.playlist.Id,
                      listMedia[index].Id),
                  trailing: getCategory(listMedia[index].getListCategoryMedia),
                ));
          }),
    );
  }

  Widget buildBt(snapshot) {
    return new FlatButton(
      color: snapshot ? Colors.green : Colors.red,
      disabledColor: Colors.grey,
      disabledTextColor: Colors.black,
      padding: EdgeInsets.all(8.0),
      splashColor: Colors.blueAccent,
      onPressed: () {
        _mediaBloc.add(AddPlaylistToMyList(
            isMyList: snapshot,
            playlist: widget.playlist,
            accountId: currentUserWithToken.Id));
      },
      child: Text(
        snapshot ? "Remove Playlist" : "+Add Playlist",
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  Text getCategory(List<CategoryMedia> listCategoryMedia) {
    String s = "#";
    listCategoryMedia.forEach((e) {
      s += e.getListCategory[0].getName + " #";
    });
    String s1 = s.substring(0, s.length - 1);
    return Text(
      s1,
      style: TextStyle(fontSize: 12),
    );
  }

  Icon currentPlay(
      List<CurrentMedia> currentMedia, String playlisID, String mediaID) {
    if (currentMedia != null) {
      if (playlisID == currentMedia[0].playlistId &&
          mediaID == currentMedia[0].mediaId) {
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
    } else {
      return Icon(
        Icons.library_music,
        color: Colors.black,
      );
    }
  }

  setUpTimedFetch() async {
    int timeToCall = 1000000;
    await getCurrentMedia();
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
      print("call api media");
      setState(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MediaView(playlist: widget.playlist, page: 2)),
        );
      });
    });
  }

  getCurrentMedia() async {
    CurrentMediaRepository repo = CurrentMediaRepository();
    final rs = await repo.getCurrentMediabyStoreId(checkedInStore.Id);
    listCurrentMedia = rs;
  }
}
