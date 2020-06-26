import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class HomePageState extends Equatable {
  HomePageState([List props = const []]) : super(props);
}

class LoadFinishState extends HomePageState {
}

class CreateState extends HomePageState {
}
class ViewPlaylists extends HomePageState {
}
class OnPushState extends HomePageState {
}


