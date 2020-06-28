import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:loginfacebook/model/store.dart';
import 'package:loginfacebook/setting/setting.dart';

class StoresNetWorkProvider {
  String baseUrl =
      Setting.baseUrl+'Stores/';
 Future<Store> getStoreById(String storeId) async {
    String url =baseUrl+
        '/'+storeId;
    final http.Response response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    if (response.statusCode == 200) {
      Store rs =  Store.fromJson(json.decode(response.body));
      return rs;
    } else {
      return null;
    }
  }
}