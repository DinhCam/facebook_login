import 'dart:convert';
import 'dart:io';

import 'package:loginfacebook/model/brand.dart';
import 'package:loginfacebook/network_provider/authentication_network_provider.dart';
import 'package:loginfacebook/setting/setting.dart';
import 'package:http/http.dart' as http;


class BrandNetWorkProvider{
    String baseUrl =
      Setting.baseUrl+'Brands';

    Future<List<Brand>> getBrandsWithPlaylists(int page) async{
      String url =
            baseUrl+'?IsSort=false&IsDescending=false&IsPaging=true&PageNumber=0&PageLimitItem=20&OrderBy=BrandName';
      final http.Response response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer ' + currentUserWithToken.Token
    });
    if (response.statusCode == 200) {
      List<dynamic> values = new List<dynamic>();
      values = json.decode(response.body);
      List<Brand> brands = new List();
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            brands.add(Brand.fromJson(map));
          }
        }
      }
      return brands;
    } else {
      throw Exception('Failed to load brands & playlists');
    }
    }
}