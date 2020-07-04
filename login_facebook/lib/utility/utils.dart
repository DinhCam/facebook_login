import 'package:flutter/material.dart';

class Utils{
static utilShowDialog(String header, String message,BuildContext context){
    showDialog(
      context: context,
      builder: (context) => AlertDialog( 
        titlePadding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: 
        BorderRadius.all(Radius.circular(15))),
        title: new Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.purple[300],
          ),
          
          child: Text(header,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),textAlign: TextAlign.center,),
          
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