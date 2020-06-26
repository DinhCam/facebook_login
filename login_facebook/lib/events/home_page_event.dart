import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomepageEvent extends Equatable {
  HomepageEvent([List props = const []]) : super(props);
}

class PageCreate extends HomepageEvent {
  @override
  String toString() => 'PageCreate';
}

class GetTop3 extends HomepageEvent {
  @override
  String toString() => 'GetTop3';
}
class GetFavorite extends HomepageEvent {
  @override
  String toString() => 'GetFavorite';
}

class GetPlaylistSuggets extends HomepageEvent {
  @override
  String toString() => 'GetPlaylistSuggets';
}
class ViewPlaylist extends HomepageEvent {
  @override
  String toString() => 'ViewPlaylist';
}
class OnPushEvent extends HomepageEvent {
  @override
  String toString() => 'ViewPlaylist';
}