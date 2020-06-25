import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:loginfacebook/model/store.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PlaylistInStoreEvent extends Equatable {
  
}

class PageCreatePIS extends PlaylistInStoreEvent {
  Store store;
  PageCreatePIS({@required this.store}) : assert(store!=null);
  @override
  String toString() => 'PageCreatePIS';
}


class PageReloadPIS extends PlaylistInStoreEvent{
  Store store;
  PageReloadPIS({@required this.store}) : assert(store!=null);
  @override
  String toString() => 'PageReloadPIS';
}
