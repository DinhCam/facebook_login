import 'package:flutter/material.dart';
import 'package:loginfacebook/bloc/search_playlist_bloc.dart';
import 'package:loginfacebook/events/search_playlist_event.dart';
import 'package:loginfacebook/model/playlist.dart';
import 'package:loginfacebook/repository/playlist_repository.dart';
import 'package:loginfacebook/view/media_view.dart';

class DataSearch extends SearchDelegate<String> {
  SearchPlaylistBloc _searchPlaylistBloc =
      SearchPlaylistBloc(playlistRepository: PlaylistRepository());
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
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
    _searchPlaylistBloc.add(SearchAllPlaylist(searchKey: query));
    return StreamBuilder<List<Playlist>>(
      stream: _searchPlaylistBloc.stream_playlistSearchKey,
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
    _searchPlaylistBloc.add(SearchSuggestPlaylist(searchKey: ""));
    query.isEmpty
        ? _searchPlaylistBloc.add(SearchSuggestPlaylist(searchKey: ""))
        : _searchPlaylistBloc.add(SearchSuggestPlaylist(searchKey: query));
    return StreamBuilder<List<Playlist>>(
      stream: _searchPlaylistBloc.stream_playlistSuggest,
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.hasData
            ? ListViewVertical(playlistsview: snapshot.data)
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}

class ListViewVertical extends StatelessWidget {
  List<Playlist> playlistsview;
  ListViewVertical({Key key, this.playlistsview}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  color: Colors.white,
                  margin: const EdgeInsets.only(top: 10),
                  alignment: Alignment.topCenter,
                  child: new OutlineButton(
                      splashColor: Colors.grey,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MediaPage(playlist: playlistsview[Index], page: 1,)),
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
                              color: Colors.black,
                            ),
                          ),
                        )
                      ])));
            }));
  }
}
