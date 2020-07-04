import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:loginfacebook/bloc/stores_bloc.dart';
import 'package:loginfacebook/events/time_submit_event.dart';
import 'package:loginfacebook/network_provider/authentication_network_provider.dart';
import 'package:loginfacebook/repository/time_submit_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:loginfacebook/states/time_submit_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class TimeSubmitBloc extends Bloc<TimeSubmitEvent, TimeSubmitState>{
  TimeSubmitRepository repository = TimeSubmitRepository();

  final _controller = StreamController<String>();
  StreamSink<String> get controller_sink => _controller.sink;
  Stream<String> get controller_stream => _controller.stream;
  TimeSubmitBloc({
    @required TimeSubmitRepository repository
  }) : assert(repository != null);

  
  @override
  // TODO: implement initialState
  TimeSubmitState get initialState => Uninitialized();

  @override
  Stream<TimeSubmitState> mapEventToState(TimeSubmitEvent event) async* {
    if(event is PageCreateTimeSubmit){
      yield* _getTimeSubmit(currentUserWithToken.Id, checkedInStore.Id);
      
    }
  }

  Stream<TimeSubmitState> _getTimeSubmit(String userID,String storeID) async*{
    final rs= await repository.getTimeSubmitByUserID(userID, storeID);
    if(rs==null){
      controller_sink.add("CanSubmit");
        yield CanSubmit();
      }else{
        var now=new DateTime.now();
        var checkTime=now.difference(rs.timeSubmit);
        if(checkTime.inMinutes > 30){
          controller_sink.add("CanSubmit");
          yield CanSubmit();
        }else{
          controller_sink.add(checkTime.inMinutes.toString());
          yield CannotSubmit(time: checkTime.inMinutes.toString());
        }
      }
  }
}