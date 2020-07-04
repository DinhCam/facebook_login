import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class TimeSubmitState extends Equatable {
  TimeSubmitState([List props = const []]) : super(props);
}
class Uninitialized extends TimeSubmitState {
}

class CanSubmit extends TimeSubmitState {

}



class CannotSubmit extends TimeSubmitState {
  String time;
  CannotSubmit({Key key, @required this.time});
}

class ErrorTimeSubmit extends TimeSubmitState {
  String error;
  ErrorTimeSubmit({Key key, @required this.error});
}


