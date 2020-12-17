
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../note.dart';



class DatabaseHelper {
  static DatabaseHelper _dbHelper;// singlton class that means throughout the life time of the application it only run once
  static Database _database;
  String noeTable='note_table';
  String colid='id';
  String coltitle='title';
  String coldescription='description';
  String colpriority='priority';
  String coldate='date';


  DatabaseHelper._createInstance();
  factory DatabaseHelper(){
    if(_dbHelper==null){
      _dbHelper =DatabaseHelper._createInstance();// this is executed olny onse if tthe db is empty

    }
    return _dbHelper;
  }
  Future<Database> get database async{
    if(_database==null){
      _database=await initializDatabase();
    }


    return _database;

  }


  Future<Database>initializDatabase() async{
    Directory directory=await getApplicationDocumentsDirectory();
    String path=directory.path +'note.db';
    var noteesdb=await openDatabase(path,version: 1,onCreate: _createDB);
    return noteesdb;

  }

  void _createDB(Database db,int newVersion)async{
    await db.execute('CREATE TABLE $noeTable( $colid INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$coltitle TEXT,'
        '$coldescription TEXT,'
        '$colpriority INTEGER,'
        '$coldate TEXT)');
  }



  Future<List<Map<String, dynamic>>>getNoteMapList() async{
    Database db=await this.database;
    var result=await db.query(noeTable,orderBy: '$colpriority ASC');
    return result;

  }
  Future<int> insertNote(Note note) async{
    Database database=await this.database;
    var result=await database.insert(noeTable, note.toMap());
    return result;
  }
  Future <int> updateNote(Note note) async{
    var db=await this.database;
    var result=await db.update(noeTable, note.toMap(),where: '$colid=?',whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(int id) async{
    var db=await this.database;
    int result=await db.rawDelete('DELETE FROM $noeTable WHERE $colid= $id');
    return result;
  }

  Future<int> getCount()async{
    Database db=await this.database;
    List<Map<String,dynamic>> x=await db.rawQuery('SELECT COUNT(*) FROM $noeTable');
    int result =Sqflite.firstIntValue(x);
    return result;
  }

  Future <List<Note>> getNoteList()async{
    var notepList=await getNoteMapList();
    int cout=notepList.length;
    List<Note> noteList=List<Note>();
    for(int i=0;i<cout;i++){
      noteList.add(Note.fromMapObject(notepList[i]));
    }
    return noteList;
  }


}