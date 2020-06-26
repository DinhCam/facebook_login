import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class StoresEvent extends Equatable {
  StoresEvent([List props = const []]) : super(props);
}

class QRCodeScan extends StoresEvent {
  @override
  String toString() => 'QRCodeScan';
}
class Init extends StoresEvent {
  @override
  String toString() => 'Init';
}
class StatusCheckIn extends StoresEvent{
  @override
  String toString() => 'StatusCheckIn';
}