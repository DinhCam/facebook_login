import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginfacebook/events/playlists_event.dart';
import 'package:loginfacebook/model/brand.dart';
import 'package:loginfacebook/model/playlist.dart';
import 'package:loginfacebook/network_provider/authentication_network_provider.dart';
import 'package:loginfacebook/repository/brand_repository.dart';
import 'package:loginfacebook/repository/media_repository.dart';
import 'package:loginfacebook/states/playlists_state.dart';

class PlaylistsBloc extends Bloc<PlaylistsEvent, PlaylistState> {
  BrandRepository _brandRepository = BrandRepository();
  MediaRepository _mediaRepository = MediaRepository();
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  final _brandwithPlaylist = StreamController<List<Brand>>();
  StreamSink<List<Brand>> get brands_sink => _brandwithPlaylist.sink;
  Stream<List<Brand>> get stream_brands => _brandwithPlaylist.stream;

  final _playlistWithMedia = StreamController<List<Playlist>>();
  StreamSink<List<Playlist>> get playists_sink => _playlistWithMedia.sink;
  Stream<List<Playlist>> get stream_playists => _playlistWithMedia.stream;

  PlaylistsBloc({@required BrandRepository brandRepository})
      : assert(brandRepository != null),
        _brandRepository = brandRepository;

  @override
  // TODO: implement initialState
  PlaylistState get initialState => Uninitialized();

  @override
  Stream<PlaylistState> mapEventToState(PlaylistsEvent event) async* {
    if (event is Loading) {
      yield* _mapLoadingToState();
    } else if (event is ViewMoreBrandPlaylists) {
      yield* _mapViewMoreBrandPlaylistsEventToState(event.playlists);
    } else if (event is LoadPlaylistsSubDetail) {
      yield* _mapLoadPlaylistsSubDetailEventToState(event.playlists);
    } else if (event is LoadSubcribeTopicEvent) {
      yield* loadChannelSubcribe(event.channel, event.context);
    } else if (event is ChageStatusSubcribe) {
      yield* changeStatusTopic(event.isSubcribe, event.channel, event.context);
    }
  }

  Stream<PlaylistState> _mapViewMoreBrandPlaylistsEventToState(
      List<Playlist> playlists) async* {
    yield LoadFinishState();
    yield ViewMoreBrandPlaylistsState(playlists: playlists);
  }

  Stream<PlaylistState> _mapLoadPlaylistsSubDetailEventToState(
      List<Playlist> playlists) async* {
    yield LoadFinishState();
    for (var item in playlists) {
      item.media = await _mediaRepository.getMediaByplaylistId(
          item.Id, 1, true, 0, 3, 1);
    }
    playists_sink.add(playlists);
    yield LoadPlaylistsSubDetailFinishState(playlists: playlists);
  }

  Stream<PlaylistState> _mapLoadingToState() async* {
    final result = await _brandRepository.getBrandWithPlaylists(0);
    if (result != null) {
      brands_sink.add(result);
      yield LoadFinishState();
    }
  }

  Stream<PlaylistState> loadChannelSubcribe(String channel, BuildContext context) async* {
    
    if (currentUserWithToken != null) {
      String uid = currentUserWithToken.Id;
      var rs = _db
          .collection('Channel')
          .document(channel)
          .collection(uid)
          .document(uid)
          .get();
      var a;
      await rs.then((value) => a=value.data);
      if (a == null) {
        yield LoadFinishState();
        yield LoadSubcribeTopicState(isSubcribe: false, context: context,brandName: channel);
      } else {
        yield LoadFinishState();
        yield LoadSubcribeTopicState(isSubcribe: true, context: context, brandName: channel);
      }
    }
  }


  Stream<PlaylistState> changeStatusTopic(bool isSubcribe, String channel, BuildContext context) async* {
    String uid = currentUserWithToken.Id;
    if (!isSubcribe) {
      try {
        var rs = _db
            .collection('Channel')
            .document(channel)
            .collection(uid)
            .document(uid);
        await rs.setData({'topic': channel});
        _fcm.subscribeToTopic(channel);
        yield LoadFinishState();
        yield ChangeSuccess(isSubcribe: !isSubcribe,brandName: channel,context: context);
      } catch (e) {
        yield LoadFinishState();
        yield ChangeError(error: e.toString());
      }
    } else {
      try {
        var rs = _db
          .collection('Channel')
          .document(channel).collection(uid).getDocuments().then((snapshot) => {
            for(DocumentSnapshot ds in snapshot.documents){
              ds.reference.delete()
            }
          });
          _fcm.unsubscribeFromTopic(channel);
        yield LoadFinishState();
        yield ChangeSuccess(isSubcribe: !isSubcribe,brandName: channel,context: context);
      } catch (e) {
        yield LoadFinishState();
        yield ChangeError(error: e.toString());
      }
    }
  }
}
