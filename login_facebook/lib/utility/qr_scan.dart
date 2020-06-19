import 'dart:typed_data';
import 'dart:ui';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class QRScan {
  String barcode = "";
  ScanResult barcodec = null;
   Future scan() async {
    try {
      String tmp = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.QR);
      this.barcode = tmp;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
          this.barcode = 'The user did not grant the camera permission!';
      } else {
         this.barcode = 'Unknown error: $e';
      }
    } on FormatException{
       this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)';
    } catch (e) {
      this.barcode = 'Unknown error: $e';
    }
  }
}