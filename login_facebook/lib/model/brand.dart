import 'dart:convert';

import 'package:loginfacebook/model/playlist.dart';

class Brand {
  final String id;
  final String brandName;
  final String companyName;
  final String address;
  final String email;
  final String phoneNumber;
  final List<Playlist> playlists;
  Brand(
      {this.id,
      this.brandName,
      this.companyName,
      this.address,
      this.email,
      this.phoneNumber,
      this.playlists});

  factory Brand.fromJson(Map<String, dynamic> json) {
    var list = json['Playlist'] as List;
    List<Playlist> playlists = null;
    if(list != null){
       playlists= list.map((i) => Playlist.fromJson(i)).toList();
    }
   
    return new Brand(
      id: json['Id'],
      brandName: json['BrandName'],
      companyName: json['CompanyName'],
      address: json['Address'],
      email: json['Email'],
      phoneNumber: json['PhoneNumber'],
      playlists: playlists,
    );
  }
}
