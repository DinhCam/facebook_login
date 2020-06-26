import 'dart:async';
import 'dart:wasm';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginfacebook/events/home_page_event.dart';
import 'package:loginfacebook/events/search_playlist_event.dart';
import 'package:loginfacebook/model/playlist.dart';
import 'package:loginfacebook/repository/playlist_repository.dart';
import 'package:loginfacebook/states/search_playlists_state.dart';



class SearchPlaylistBloc extends Bloc<SearchPlaylistsEvent, SearchPlaylistState> {
  PlaylistRepository _playlistRepository = PlaylistRepository();

  final _playlistSuggestController = StreamController<List<Playlist>>();
  StreamSink<List<Playlist>> get playlistSuggest_sink =>
      _playlistSuggestController.sink;
  Stream<List<Playlist>> get stream_playlistSuggest =>
      _playlistSuggestController.stream;

   final _playlistWithSearchKeyController = StreamController<List<Playlist>>();
  StreamSink<List<Playlist>> get playlistSearchKey_sink =>
      _playlistWithSearchKeyController.sink;
  Stream<List<Playlist>> get stream_playlistSearchKey =>
      _playlistWithSearchKeyController.stream;


  SearchPlaylistBloc({@required PlaylistRepository playlistRepository})
      : assert(playlistRepository != null),
        _playlistRepository = playlistRepository;

  Future getPlaylistsBySearchkey(String searchKey, int numberItem) async{
    final tmp = await  _playlistRepository.getPlaylistsBySearchKey(searchKey);
    playlistSearchKey_sink.add(tmp);
  }
  Future getPlaylistsSuggest(String searchKey, int numberItem) async{
    final tmp = await  _playlistRepository.getPlaylistsBySearchKey(searchKey);
    playlistSuggest_sink.add(tmp);
  }

  @override
  SearchPlaylistState get initialState => Uninitialized();

  @override
  Stream<SearchPlaylistState> mapEventToState(SearchPlaylistsEvent event) async*{
    if (event is SearchSuggestPlaylist) {
       await getPlaylistsSuggest(event.searchKey, 10);
      yield SearchSuggestState();
    }else if(event is SearchAllPlaylist){
       await getPlaylistsBySearchkey(event.searchKey, 30);
      yield SearchAllPlaylistsState();
    }
  }



  
}
