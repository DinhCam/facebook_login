import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class PlaylistInStoreState extends Equatable {
  
}

class CreatePagePISState extends PlaylistInStoreState {

}



class PageReloadPISState extends PlaylistInStoreState {

}

class SubmitSuccess extends PlaylistInStoreState{

}

class SubmitFail extends PlaylistInStoreState{

}
class SubmitWrongBrand extends PlaylistInStoreState{
  String error;
  SubmitWrongBrand({Key key, @required this.error});
}


