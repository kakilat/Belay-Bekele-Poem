import 'package:device_info/device_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:share/share.dart';

import 'model/Detail.dart';
import 'model/note.dart';

class SavedDtail extends StatefulWidget {
  final String  title,date;

  SavedDtail(this.title,this.date);

  @override
  _SavedDtailState createState() => _SavedDtailState(this.title,this.date);
}

class _SavedDtailState extends State<SavedDtail> {

  final String  title,date;

  _SavedDtailState(this.title ,this.date);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      ),
      body: Card(
        elevation: 5,
        borderOnForeground: true,
        child: Container(
          decoration: new BoxDecoration(
            color: Color.fromRGBO(64, 75, 96, .9),
            //here i want to add opacity

            border: new Border.all(
              color: Colors.black54,
            ),
          ),
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                    child: ClipOval(
                      child: Image.asset(
                        'images/tt.jpg',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(title,
                      style: TextStyle(
                        color:Colors.white,
                        fontSize: 22
                      ),),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Container(
                    child: SingleChildScrollView(
                        child: Html(data: date,
                        defaultTextStyle: TextStyle(
                          color: Colors.white70
                              ,
                          fontSize: 20
                        ),)),
              ),

              //
              )],
          ),
        ),
      ),
      bottomNavigationBar: new BottomAppBar(
        color: Color.fromRGBO(58, 66, 86, 1.0),
        child: new Container(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

            ],
          ),
        ),
      ),
    );
  }




}
