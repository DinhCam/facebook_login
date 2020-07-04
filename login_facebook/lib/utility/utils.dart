import 'package:flutter/material.dart';

class Utils{
static utilShowDialog(String header, String message,BuildContext context){
    showDialog(
      context: context,
      builder: (context) => AlertDialog( 
        titlePadding: EdgeInsets.all(0),

        title: new Container(
          color: Colors.purple[300],
          child: Text(header,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),textAlign: TextAlign.center,),
          padding: EdgeInsets.all(0.0),
          margin: EdgeInsets.all(0),
        ),                 
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            color: Colors.purple[300],
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(8.0),
            splashColor: Colors.blueAccent,       
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}