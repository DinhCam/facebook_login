import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:loginfacebook/model/media.dart';
import 'package:loginfacebook/repository/media_repository.dart';

class MediaBloc {
  MediaRepository _mediaRepository = MediaRepository();

  final _mediaController = StreamController<List<Media>>();
  StreamSink<List<Media>> get media_sink => _mediaController.sink;
  Stream<List<Media>> get media_stream => _mediaController.stream;


  MediaBloc({@required MediaRepository mediaRepository})
      : assert(mediaRepository != null),
        _mediaRepository = mediaRepository;

  void getMediaByPlaylistId(String playlistId,bool isSort, bool isDesending, bool isPaging, int pageNumber, int pageLimit, int typeMedia ) async{
    final tmp = await _mediaRepository.getMediaByplaylistId(playlistId, isSort, isDesending, isPaging, pageNumber, pageLimit, typeMedia );
    media_sink.add(tmp);
  } 
  
  } 
