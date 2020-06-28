import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:loginfacebook/events/playlist_in_store_event.dart';
import 'package:loginfacebook/model/current_media.dart';
import 'package:loginfacebook/model/playlist_in_store.dart';
import 'package:loginfacebook/repository/current_media_repository.dart';
import 'package:loginfacebook/repository/playlist_in_store_repository.dart';
import 'package:loginfacebook/states/playlist_in_store_state.dart';
import 'package:bloc/bloc.dart';


class PlaylistInStoreBloc extends Bloc<PlaylistInStoreEvent, PlaylistInStoreState>{
  PlaylistInStoreRepository _playlistInStoreRepo = PlaylistInStoreRepository();
  CurrentMediaRepository _currentMediaRepo= CurrentMediaRepository();

  final _playlistInStoreController = StreamController<List<PlaylistInStore>>();
  StreamSink<List<PlaylistInStore>> get pis_sink => _playlistInStoreController.sink;
  Stream<List<PlaylistInStore>> get pis_stream => _playlistInStoreController.stream;

  final _currentMediaController = StreamController<List<CurrentMedia>>();
  StreamSink<List<CurrentMedia>> get currentMedia_sink => _currentMediaController.sink;
  Stream<List<CurrentMedia>> get currentMedia_stream => _currentMediaController.stream;

 PlaylistInStoreBloc({
   @required PlaylistInStoreRepository playlistInStoreRepo,
   @required CurrentMediaRepository currentMediaRepo
 }) : assert(playlistInStoreRepo!=null && currentMediaRepo!=null),
 _currentMediaRepo=currentMediaRepo,_playlistInStoreRepo=playlistInStoreRepo;

  void getPlaylistInStore(String storeId,int sortType, bool isPaging, int pageNumber, int pageLimit) async{
    final rs = await _playlistInStoreRepo.getPlaylistInStoreByStoreId(storeId, sortType, isPaging, pageNumber, pageLimit);
    pis_sink.add(rs);
  }
  void getCurrentMedia(String storeId) async{
    final rs= await _currentMediaRepo.getCurrentMediabyStoreId(storeId);
    currentMedia_sink.add(rs);
  }

  @override
  // TODO: implement initialState
  PlaylistInStoreState get initialState => CreatePagePISState();

  @override
  Stream<PlaylistInStoreState> mapEventToState(PlaylistInStoreEvent event) async*{
    if(event is PageCreatePIS){
      await getCurrentMedia(event.store.Id);
      await getPlaylistInStore(event.store.Id, 1, true, 0, 10);  
      yield CreatePagePISState();
    }else if(event is PageReloadPIS){
      await getCurrentMedia(event.store.Id);
      await getPlaylistInStore(event.store.Id, 1, true, 0, 10);  
      yield PageReloadPISState();
    }
  }
  
}