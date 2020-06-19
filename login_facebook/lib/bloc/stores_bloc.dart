import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:loginfacebook/bloc/home_page_event.dart';
import 'package:loginfacebook/bloc/stores_event.dart';
import 'package:loginfacebook/bloc/stores_state.dart';
import 'package:loginfacebook/model/store.dart';
import 'package:loginfacebook/repository/stores_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:loginfacebook/utility/qr_scan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoresBloc extends Bloc<StoresEvent, StoresState> {
  StoresRepository _storesRepository = StoresRepository();

  final _storeController = StreamController<Store>();
  StreamSink<Store> get store_sink => _storeController.sink;
  Stream<Store> get store_stream => _storeController.stream;

  StoresBloc({@required StoresRepository storesRepository})
      : assert(storesRepository != null),
        _storesRepository = storesRepository;

  @override
  // TODO: implement initialState
  StoresState get initialState => Uninitialized();

  @override
  Stream<StoresState> mapEventToState(StoresEvent event) async* {
    // TODO: implement mapEventToState
    if (event is QRCodeScan) {
      QRScan qrScan = QRScan();
      await qrScan.scan();
      String id = qrScan.barcode;
      if (id == '-1') {
        yield QRScanCancel(null);
      } else {

        final scanResult = await _storesRepository.getMediaByplaylistId(id);
        if (scanResult != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("storeId", scanResult.Id);
          store_sink.add(scanResult);
          yield QRScanSuccess(scanResult);
        } else {
          yield QRScanFail("Store QR Code is invalid!");
        }
      }
    }
  }
}
