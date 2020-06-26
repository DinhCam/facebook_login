import 'package:flutter/material.dart';
import 'package:loginfacebook/bloc/stores_bloc.dart';

import 'home_view.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Favorite Page"),
        ),
        body: new Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      "assets/pngtree-purple-brilliant-background-image_257402.jpg"),
                  fit: BoxFit.cover)),
          child: new Column(children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                      color: Color.fromARGB(100, 187, 171, 201)),
                  padding: EdgeInsets.fromLTRB(32, 10, 30, 10),
              child: new Row(
                
              ),
            )
          ]),
        ));
  }
}
