import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:loginfacebook/model/store.dart';

@immutable
abstract class StoresState extends Equatable {
  StoresState([List props = const []]) : super(props);
}

class Uninitialized extends StoresState {
}

class QRScanSuccess extends StoresState {
  final Store store;

  QRScanSuccess(this.store) : super([store]);
}
class QRScanFail extends StoresState {
  final String messages;

  QRScanFail(this.messages) : super([messages]);
}
class QRScanCancel extends StoresState {
  final String messages;

  QRScanCancel(this.messages) : super([messages]);
}