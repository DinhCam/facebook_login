import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:loginfacebook/model/time_submit.dart';
import 'package:loginfacebook/setting/setting.dart';

class TimeSubmitNetworkProvider {
  String baseUrl =
      Setting.baseUrl+'TimeSubmits/';
 Future<TimeSubmit> getTimeSubmitByUserID(String userID,String storeID) async {
    String url =baseUrl+
        '/'+userID+'/'+storeID;
    final http.Response response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    if (response.statusCode == 200) {
      TimeSubmit rs =  TimeSubmit.fromJson(json.decode(response.body));
      return rs;
    } else {
      return null;
    }
  }
}