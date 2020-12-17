

class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  String _prioriy;


  Note(this._title, this._date, this._description);
  Note.withId(this._id, this._title, this._description, this._date, this._prioriy);

  String get prioriy => _prioriy;

  set prioriy(String newPriority) {

  }

  String get date => _date;

  set date(String newDate) {
    _date = newDate;
  }

  String get description => _description;

  set description(String newDescriprtion) {
    if(newDescriprtion.length<=255){
      _description = newDescriprtion;
    }
  }

  String get title => _title;

  set title(String newTitle) {
    if(newTitle.length<=255){
      _title = newTitle;
    }
  }

  int get id => _id;

  set id(int newId) {
    _id = newId;
  }


  Map<String, dynamic>toMap(){
    var map=Map<String,dynamic>();

    if(id!=null){
      map['id']=_id;
    }
    map['title']=_title;
    map['description']=_description;
    map['date']=_date;

    return map;


  }

  Note.fromMapObject(Map<String,dynamic>map){
    this._id=map['id'];
    this._description=map['description'];
    this._title=map['title'];
    this._date=map['date'];

  }


}