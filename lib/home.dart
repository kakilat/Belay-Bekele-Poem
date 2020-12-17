import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ethionews/allnewsMain.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';
import

class SetupInformation extends StatefulWidget {

  @override
  _SetupInformationState createState() => _SetupInformationState();
}

class _SetupInformationState extends State<SetupInformation> {


  var relation='AllNews';
  Text text=Text("");
  String uri,username,usernickname,dob,dvId;
  DateTime _date;

  Future<Null> selectDate(BuildContext context) async{
    final DateTime picked=await showDatePicker(
      context:context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if(picked!=null&& picked!=_date){
      setState(() {

        _date=picked;
      });
    }
  }
  TextEditingController name= TextEditingController();
  TextEditingController nickName= TextEditingController();
  File _image;
  Future<void> addData(context,collection,title,content,imageurl,date)async{

    Firestore.instance.collection(collection).add({
      "title":title,
      "image": imageurl,
      "content":content,
      "date":date,

    });
 Navigator.pop(context);
  }



  @override
  Widget build(BuildContext context) {

    Future getImage()async{
      var image=await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image=image;
      });
    }
    Future uploadPic(context,collection,title,content,uri,date)async{
      String filename=basename(_image.path);
      StorageReference fibasestorage=FirebaseStorage.instance.ref().child("NewsImage").child(filename);
      StorageUploadTask uploadTask=fibasestorage.putFile(_image);
      StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
      var Imageuri=await (await uploadTask.onComplete).ref.getDownloadURL();
      if(taskSnapshot!=null){

        addData(context,collection,title,content,Imageuri,date);
      }
    }

    return Scaffold(

      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

      ),
      body: Column(
        children: <Widget>[

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft:Radius.circular(30),
                        topRight: Radius.circular(30))
                ),
                child:  SingleChildScrollView(
                  child: Builder(
                    builder: (context) => Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                           InkWell(
                             onTap: () {
                               getImage();
                             },
                             child: Container(
                               color: Colors.black,
                               child: SizedBox(
                                width:300,
                                height: 300,
                                child:(_image!=null)?Image.file(_image,fit: BoxFit.fill,)
                                    :Image.asset(
                                  "logos/kana.jpg",
                                  fit: BoxFit.fill,
                                ),
                          ),
                             ),
                           ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "title",
                                        ),
                                      ),
                                      SizedBox(height: 4,),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child:  TextField(
                                          onChanged: (String fullname){
                                            setState(() {
                                              username=fullname;
                                            });
                                          },
                                          controller: name,
                                          decoration: InputDecoration(
                                              labelText: "Full Name",
                                              hintText: "Abebe Kebede",
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(6)
                                              )
                                          ),

                                        ),

                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "content",

                                        ),
                                      ),
                                      SizedBox(height: 4,),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child:  TextField(
                                          controller: nickName,
                                          onChanged: (String newname){
                                            setState(() {
                                              usernickname=newname;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            labelText: "Nick Name",
                                            hintText: "Abuchu",
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(6)
                                            ),

                                          ),
                                          onEditingComplete: null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "Postd Date",

                                        ),
                                      ),
                                      SizedBox(height: 4,),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child:IconButton(
                                          icon: Icon(Icons.date_range,
                                            color: Colors.blueGrey,),
                                          iconSize: 40,
                                          onPressed: (){
                                            selectDate(context);
                                            setState(() {
                                              dob=_date.toString();
                                            });
                                          },
                                        ),
                                      ),Align(
                                        alignment: Alignment.centerLeft,
                                        child:(_date!=null)?Container(child: Text(_date.day.toString()+"-"+_date.month.toString()+"-"+_date.year.toString())):
                                        Text(""),

                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "News Type",

                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child:  DropdownButton<String>(
                                          items: <String>['AllNews', 'InternationalAllNews','LocalNews','SportNews','PoliticalNews'].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (String newRelation){
                                            setState(() {
                                              this.relation=newRelation;
                                            });
                                          },
                                          value: relation,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RaisedButton(
                                color: Colors.blue,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                elevation: 4.0,
                                splashColor: Colors.blueGrey,
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                              RaisedButton(
                                color: Colors.blue,
                                onPressed: () {
                                  uploadPic(context,relation,username,usernickname,uri,(_date.day.toString()+"-"+_date.month.toString()+"-"+_date.year.toString()+": GC"));

                                },
                                elevation: 4.0,
                                splashColor: Colors.blueGrey,
                                child: Text(
                                  "Save",
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              )
                            ],
                         