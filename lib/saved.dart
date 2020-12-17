import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share/share.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'model/note.dart';
import 'model/utils/database.dart';
import 'saved_dtail.dart';

class PoimList extends StatefulWidget {



  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<PoimList> {
  DatabaseHelper datbaseHelper=DatabaseHelper();
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count=0;


  @override
  Widget build(BuildContext context) {
    if(noteList==null){
      noteList=List<Note>();
      updateListView();
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),

        title: Text('Saved Poims'),
      ),
      body: getNoteListView(),

    );
  }
  ListView getNoteListView(){

    TextStyle textStyle=Theme.of(context).textTheme.subhead;
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context,int position){
          return Slidable(
            key: ValueKey(position),
            actionPane: SlidableDrawerActionPane(),
            actions: <Widget>[
              IconSlideAction(
                caption: 'Archive',
                color: Colors.blueGrey,
                icon: Icons.delete,
                onTap: (){
                  _delete(context,noteList[position]);
                },
              )
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Share',
                color: Colors.blueGrey,
                icon: Icons.share,
                onTap: (){
                  String containt=Html(data: noteList[position].description,).toString();
                 Share.share(noteList[position].title,subject:containt);
                },
              ),

            ],

            child: Card(
                elevation: 10.0,
                color: Color.fromRGBO(64, 75, 96, .9),
                margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Column(
              children: <Widget>[
                Container(
                  height: 100,
                  decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                  child: SingleChildScrollView(child:ListTile(
                    title: Row(children: <Widget>[
                      Text(this.noteList[position].title,style: TextStyle(
                        color: Colors.white
                      ),),
                    ],),

                    subtitle: Html(data: this.noteList[position].description,
                    defaultTextStyle: TextStyle(
                      color: Colors.white70
                    ),),
                    onTap: (){


                    },
                  ), )
                ),
                Container(
                  padding: EdgeInsets.only(right: 15),
                  alignment: Alignment.bottomRight,
                  decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                 child: GestureDetector(child: Icon(Icons.arrow_forward,
                   color: Colors.white,
                  ),
                    onTap: (){
                      _OpenSavedLinks(noteList[position].title,noteList[position].description);
                    },
                  ),
                ),
              ],
            )),
          );
        });
  }

  updateListView(){
    final Future<Database> dbFuture=datbaseHelper.initializDatabase();
    dbFuture.then((database){
      Future<List<Note>> notelistFuture=datbaseHelper.getNoteList();
      notelistFuture.then((notelist){
        setState(() {
          this.noteList=notelist;
          this.count=notelist.length;
        });
      });
    });
  }

  _OpenSavedLinks(String title,String date){
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SavedDtail(title,date);
    }));
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnakBar(context, 'Data Deleted Secessfully');
       updateListView();
    }
  }
  void _showSnakBar(BuildContext context, String message) {
    final snakBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snakBar);
  }
}
