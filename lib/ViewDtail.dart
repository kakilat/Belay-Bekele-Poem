
import 'package:device_info/device_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'model/Detail.dart';
import 'package:share/share.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/note.dart';
import 'model/utils/database.dart';




class ViewDetail extends StatefulWidget {
DocumentSnapshot snapshot;

  ViewDetail(this.snapshot);

  @override
  _ViewDetailState createState() => _ViewDetailState(this.snapshot);
}

class _ViewDetailState extends State<ViewDetail> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  final DocumentSnapshot snapshot;
   String dvid='12345';
  _ViewDetailState(this.snapshot);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _TextStye() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        appBar: AppBar(
          title: Text(
            snapshot["title"],
          ),
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
                        child: Text(snapshot["title"],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            )),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Container(
                      child: SingleChildScrollView(
                          child: Html(
                            data: snapshot["data"],
                            defaultTextStyle: TextStyle(color: Colors.white70, fontSize: 22),
                          ))),
                ),
                //
              ],
            ),
          ),
        ),
        bottomNavigationBar: new CurvedNavigationBar(
          color: Color.fromRGBO(58, 66, 86, 1.0),
          items: <Widget>[
            Icon(
              Icons.thumb_up,
              color: Colors.blue.shade100,
              size: 20,
            ),
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
        ));
  }

  _chackIndex(int i) {
    if (i == 0) {
    //  _SaveToFavrite(snapshot);
    } else if (i == 1) {
      Share.share(snapshot["title"], subject: snapshot["data"]);
    } else if (i == 2) {
      _SaveDataToDatabase();
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  getDvInfo() async {
    DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    var bradid = androidDeviceInfo.androidId;
    setState(() {
      dvid = bradid;
    });
  }



  void _SaveDataToDatabase() async {

    int result = await databaseHelper
        .insertNote(Note(snapshot["title"], snapshot["date"], snapshot["data"]));
    if (result != 0) {
      _showAlertDialog(snapshot["title"], 'Saved Sucessfully');
    } else {
      _showAlertDialog('Status', 'Unable To Save Your Data');
    }
  }
}
