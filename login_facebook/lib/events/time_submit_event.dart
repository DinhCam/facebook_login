import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TimeSubmitEvent extends Equatable {
  
}

class PageCreateTimeSubmit extends TimeSubmitEvent {
  @override
  String toString() => 'PageCreateTimeSubmit';
}
class ClickBtTimeSubmit extends TimeSubmitEvent{
  @override
  String toString() => 'ClickBtTimeSubmit';
}


