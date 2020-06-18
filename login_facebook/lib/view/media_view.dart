import 'package:flutter/material.dart';
import 'package:loginfacebook/bloc/media_bloc.dart';
import 'package:loginfacebook/events/media_event.dart';
import 'package:loginfacebook/model/media.dart';
import 'package:loginfacebook/model/playlist.dart';
import 'package:loginfacebook/repository/media_repository.dart';

import 'home_view.dart';

class MediaPage extends StatelessWidget {
  Playlist playlist;
  List<Playlist> listMyFavorite;
  MediaPage({Key key, @required this.playlist, @required this.listMyFavorite}) : super(key: key);

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
      home: new MediaView(playlist: playlist,listMyFavorite: listMyFavorite),
    );
  }
}

class MediaView extends StatefulWidget {
  Playlist playlist;
  List<Playlist> listMyFavorite;
  MediaView({Key key, @required this.playlist, @required this.listMyFavorite}) : super(key: key);
  @override
  _MediaViewState createState() => _MediaViewState();
}

class _MediaViewState extends State<MediaView> {
  MediaBloc _mediaBloc;
  List<Media> listMedia = new List();

  bool isPress=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mediaBloc = MediaBloc(mediaRepository: MediaRepository());
    
    _mediaBloc.dispatch(PageCreateMedia(playlist: widget.playlist,listFavorite: widget.listMyFavorite));
    
    
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // backgroundColor: Colors.blue[1000],
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          title: new Text(widget.playlist.PlaylistName),
          leading: new IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
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
                      image: NetworkImage(widget.playlist.ImageUrl),
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
                      new Text(widget.playlist.PlaylistName, style: TextStyle(fontSize: 26.0),),
                      StreamBuilder(
                        stream: _mediaBloc.addPlaylist_stream,
                        builder: (context, snapshot){
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
        ]));
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
              decoration:
                  new BoxDecoration(color: Color.fromARGB(50, 187, 171, 201)),
              child: new ListTile(
                title: new Text(
                    (index + 1).toString() + ". " + listMedia[index].MusicName,style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
                subtitle: new Text(
                    "  singer: "+listMedia[index].Singer + " ,author: " + listMedia[index].Author, style: TextStyle(fontSize: 14.0),),
                leading: Icon(Icons.library_music),
              ));
        }),
    );
  }
  Widget buildBt(snapshot){
    return new FlatButton(
      color: snapshot? Colors.green : Colors.red,
      disabledColor: Colors.grey,
      disabledTextColor: Colors.black,
      padding: EdgeInsets.all(8.0),
      splashColor: Colors.blueAccent,
      onPressed: () {
        _mediaBloc.dispatch(AddPlaylistToMyList(isMyList: snapshot, listFavorite: widget.listMyFavorite, playlist: widget.playlist));
      },
      child: Text(
        "+Add Playlist",
        style: TextStyle(fontSize: 20.0),
      ),);
  }

}
