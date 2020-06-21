import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:loginfacebook/model/media.dart';
import 'package:loginfacebook/repository/favorite_playlist_repository.dart';
import 'package:loginfacebook/repository/media_repository.dart';
import 'package:loginfacebook/events/media_event.dart';
import 'package:loginfacebook/model/playlist.dart';
import 'package:loginfacebook/repository/playlist_repository.dart';
import 'package:loginfacebook/states/media_state.dart';
import 'package:bloc/bloc.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState>{
  MediaRepository _mediaRepository = MediaRepository();
  PlaylistRepository _playlistRepository = new PlaylistRepository();
  FavoritePlaylistRepository _favoritePlaylistRepository = new FavoritePlaylistRepository();
// >>>>>>> db28e008d9ec227333b74c8734eddee4ad0750fa

  final _mediaController = StreamController<List<Media>>();
  StreamSink<List<Media>> get media_sink => _mediaController.sink;
  Stream<List<Media>> get media_stream => _mediaController.stream;


  final _addPlaylistToMyFavoriteController = StreamController();
  StreamSink get addPlaylist_sink => _addPlaylistToMyFavoriteController.sink;
  Stream get addPlaylist_stream => _addPlaylistToMyFavoriteController.stream;


  MediaBloc({@required MediaRepository mediaRepository})
      : assert(mediaRepository != null),
        _mediaRepository = mediaRepository;

  void getMediaByPlaylistId(String playlistId,int sortType, bool isPaging, int pageNumber, int pageLimit, int typeMedia ) async{
    final rs = await _mediaRepository.getMediaByplaylistId(playlistId, sortType, isPaging, pageNumber, pageLimit, typeMedia );
    media_sink.add(rs);
  }
  void getStatusForButton( Playlist playlist) async{
    bool flag = false;
    var listPlaylist=await _playlistRepository.getUserFavoritesPlaylist();
    if(listPlaylist!=null){
      listPlaylist.forEach((e) {
      if(e.Id == playlist.Id){    
        flag = true;
      }
    }); 
    }
    if(flag){
      addPlaylist_sink.add(true);
    }else{
      addPlaylist_sink.add(false);
    }
    
    
  }
  void addplaylist(Playlist playlist, bool isMyList, String accountId){
    if(isMyList){
      _favoritePlaylistRepository.deleteFavoritePlaylist(playlist.Id, accountId);
      addPlaylist_sink.add(!isMyList);
    }else{
      _favoritePlaylistRepository.addFavoritePlaylist(playlist.Id, accountId);
      addPlaylist_sink.add(!isMyList);
    }
    
    
  }

  @override
  // TODO: implement initialState
  MediaState get initialState => CreatePageMediaState();

  @override
  Stream<MediaState> mapEventToState(MediaEvent event) async*{
    if(event is PageCreateMedia){
      await getMediaByPlaylistId(event.playlist.Id, 1, false, 0, 0, 1);
      await getStatusForButton(event.playlist);
      yield CreatePageMediaState();
    }else if(event is AddPlaylistToMyList){
      await addplaylist(event.playlist, event.isMyList , event.accountId);
      yield AddButton();
    }
  } 
  
  
  } 
