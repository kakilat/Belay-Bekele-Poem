
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share/share.dart';

import 'model/note.dart';
import 'model/utils/database.dart';


class NewDetail extends StatefulWidget {
  DocumentSnapshot snapshot;
  NewDetail(this.snapshot);



  @override
  _NewDetailState createState() => _NewDetailState(this.snapshot);


}

class _NewDetailState extends State<NewDetail> {
  DocumentSnapshot snapshot;
  _NewDetailState(this.snapshot);
  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(
            snapshot["title"]
        ),
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      ),
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: ListView(
        children: <Widget>[

          SizedBox(height: 7.0,),
          Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: Color.fromRGBO(64, 75, 96, .9),
                borderRadius: BorderRadius.only(topRight: Radius.circular(40),topLeft: Radius.circular(40))
            ),
            child: Card(
              elevation: 10.0,
              color: Color.fromRGBO(64, 75, 96, .9),
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(

                    margin:EdgeInsets.all(5) ,
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          child:Text( widget.snapshot["title"][0]),
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                        ),
                        SizedBox(width: 6,),
                        Text(widget.snapshot["title"],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),)
                      ],
                    ),
                  ),

                  SizedBox(height: 10,),
                  Container(
                    margin: EdgeInsets.all(6) ,
                    child: Text(" 100 views",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.deepOrangeAccent
                      ),),
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    margin: EdgeInsets.all(6.0),
                    child: Html(data:widget.snapshot["data"],

                  ))
                ],
              ),

            ),
          ) ],
      ),
        bottomNavigationBar: new CurvedNavigationBar(
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          items: <Widget>[

            Icon(
              Icons.share,
              color: Colors.blue.shade100,
              size: 20,
            ),
            Icon(
              Icons.file_download,
              color: Colors.blue.shade100,
              size: 20,
            ),
          ],
          onTap: (i) {
            setState(() {
              _chackIndex(i);
              ;
            });
          },
        )
    );
  }
  _chackIndex(int i) {
    if (i == 0) {
      Share.share(snapshot["title"], subject:snapshot["data"]);
    }  else if (i == 1) {
      _SaveDataToDatabase();
    }
  }

  void _SaveDataToDatabase() async {

    int result = await databaseHelper
        .insertNote(Note(snapshot["title"], snapshot["date"], snapshot["data"]));
    if (result != 0) {
      _showAlertDialog('Status', 'Data saved Sucessfully');
    } else {
      _showAlertDialog('Status', 'Unable To Save Your Data');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
