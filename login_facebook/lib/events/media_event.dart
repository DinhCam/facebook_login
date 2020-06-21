import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:loginfacebook/model/playlist.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MediaEvent extends Equatable {
  
}

class PageCreateMedia extends MediaEvent {
  Playlist playlist;
  PageCreateMedia({@required this.playlist}) : assert(playlist!=null);
  @override
  String toString() => 'PageCreate';
}


class AddPlaylistToMyList extends MediaEvent{
  Playlist playlist;
  bool isMyList;
  String accountId;
  AddPlaylistToMyList({@required this.playlist, @required this.isMyList,@required this.accountId}) : assert(playlist!=null && isMyList !=null && accountId != null);
}
