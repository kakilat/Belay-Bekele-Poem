
import 'package:belay/saved.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share/share.dart';
import 'dart:io';

import 'ViewDtail.dart';
import 'model/note.dart';
import 'model/utils/database.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {



  MobileAdTargetingInfo targetingInfo = new MobileAdTargetingInfo(
    testDevices: <String>[],
    keywords: <String>['wallpepares', 'walls', 'amoled'],
    birthday: new DateTime.now(),
    childDirected: true,
  );


  BannerAd _bannerAd;


  DatabaseHelper databaseHelper = DatabaseHelper();

  Future getAllPoem() async {
    var firestore = Firestore.instance;
    QuerySnapshot snapshot = await firestore.collection("Poem").getDocuments();
    return snapshot.documents;
  }

  Future<Null> getRefresh() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      getAllPoem();
    });
  }
  BannerAd createBannerAd()
  {
    return new BannerAd(adUnitId:"",
        size: AdSize.banner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event){
          print("Banner Event ");

        }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAdMob.instance.initialize(appId:"");
    _bannerAd=createBannerAd()
      ..load()
      ..show();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("በላይ በቀለ ወያ የግጥም ስብስቦች "),
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      ),
      drawer: Drawer(
        child: Container(
          color: Color.fromRGBO(58, 66, 86, 1.0),
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,

            children: <Widget>[
              DrawerHeader(
                child: Text(""),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'images/belay.png',
                      ),
                      fit: BoxFit.fill),
                  color: Color.fromRGBO(58, 66, 86, 1.0),
                ),
              ),
              ListTile(
                title: Text("Share App",
                  style: TextStyle(
                      color: Colors.white,
                    fontSize: 16
                  ),),
                leading: Icon(Icons.share,
                color: Colors.lightBlueAccent,),
                //color: Color.fromRGBO(58, 66, 86, 1.0),
                onTap: () {
                  Share.share('check out my website https://example.com');
                },
              ),
              ListTile(
                title: Text("Saved",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                  ),),
                leading: Icon(Icons.offline_pin,
                color: Colors.lightBlueAccent,),
                //color: Color.fromRGBO(58, 66, 86, 1.0),
                onTap: () {
                  _RetriveFromDb();
                },
              ),
              ListTile(
                title: Text("Other Apps",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                  ),),
                leading: Icon(Icons.apps,
                color: Colors.lightBlueAccent,),
                //color: Color.fromRGBO(58, 66, 86, 1.0),
                onTap: () {
                  // _RetriveFromDb();
                },
              ),
              ListTile(
                title: Text("Rate 💫💫",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                  ),),
                leading: Icon(Icons.stars,
                color: Colors.lightBlueAccent,),
                //color: Color.fromRGBO(58, 66, 86, 1.0),
                onTap: () {},
              )
            ],
          ),
        ),
      ),
      body:Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        body: FutureBuilder(
          future: getAllPoem(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Center(child: CircularProgressIndicator()),
              );
            } else {
              return RefreshIndicator(
                onRefresh: getRefresh,
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Slidable(
                      key: ValueKey(index),
                      actionPane: SlidableDrawerActionPane(),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Save',
                          color: Colors.blueGrey,
                          icon: Icons.save,
                          onTap: () {
                            var title, date, data;
                            title = snapshot.data[index].data["title"];
                            data = snapshot.data[index].data["data"];
                            date = snapshot.data[index].data["date"];

                            _SaveDataToDatabase(title, date, data);
                          },
                        ),
                        IconSlideAction(
                          caption: 'Share',
                          color: Colors.blueGrey[600],
                          icon: Icons.share,
                          onTap: () {
                            var title, date, data;
                            title = snapshot.data[index].data["title"];
                            data = Html(data: snapshot.data[index].data["data"],).toString();
                            Share.share(title, subject: data);
                          },
                        ), //
                      ],
                      child: new Container(
                        width: MediaQuery.of(context).size.width,
                        height: 240,
                        //height: MediaQuery.of(context).size.height - 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10)
                            )),
                        child: GestureDetector(
                          onTap: () {
                            // _SendToNextScreen(title, data, date, index);
                            //  _SaveToView(index);
                          },
                          child: Card(
                            color: Color.fromRGBO(64, 75, 96, .9),
                            elevation: 5.0,
                            margin: new EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Column(
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
                                              )),
                                          Text(
                                            "በላይ በቀለ ወያ ",
                                            style: TextStyle(
                                              color: Colors.black,),
                                          )
                                        ],
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.topRight,
                                          margin:
                                          EdgeInsets.only(right: 5),
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                "Date",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white70,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                ),
                                              ),
                                              Text(snapshot.data[index]
                                                  .data["date"],
                                                style: TextStyle(
                                                    color: Colors.white70
                                                ),),
                                              SizedBox(
                                                height: 9,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      snapshot
                                          .data[index].data["title"],
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                        child: Center(
                                          child: SingleChildScrollView(
                                              child: Html(
                                                data: snapshot
                                                    .data[index]
                                                    .data["data"],
                                                padding: EdgeInsets.all(8.0),
                                                defaultTextStyle: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 15

                                                ),)),
                                        )),
                                  ),

                                  Container(
                                    child: Card(
                                      color: Color.fromRGBO(
                                          64, 75, 96, .9),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[

                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                SizedBox(width: 30,),
                                                Icon(
                                                  Icons.remove_red_eye,
                                                  color: Colors.orange[100],
                                                ),
                                                Text(
                                                  "45k Views",
                                                  style: TextStyle(
                                                      color: Colors
                                                          .orange[100],
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: (){
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                                                  ViewDetail(snapshot.data[index])));
                                            },
                                            child: Container(
                                              width: 100,
                                              alignment: Alignment.bottomRight,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                  color: Colors.blueGrey
                                              ),

                                              child: Center(
                                                child: Text(
                                                  "View More",
                                                  style: TextStyle(
                                                    color: Colors.white,

                                                    fontSize: 15,

                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      )
    );
  }

  void _RetriveFromDb() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PoimList();
    }));
  }

  void _SaveDataToDatabase(String title, String date, String data) async {
    int result = await databaseHelper.insertNote(Note(title, date, data));
    if (result != 0) {
      _showAlertDialog("Saved", 'You have saved ' + title + ' Ofline');
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
/**/
