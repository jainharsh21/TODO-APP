import 'package:flutter/material.dart';

class DoItem extends StatelessWidget {

  String _itemName;
  String _dateCreated;
  int _id;

  DoItem(this._itemName,this._dateCreated);

  DoItem.map(dynamic obj)
  {
    this._itemName = obj["itemName"];
    this._dateCreated = obj["dateCreated"];
    this._id = obj["id"];
  }

  String get itemName => _itemName;
  String get dateCreated => _dateCreated;
  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = new Map<String,dynamic>();
    map["itemName"] = _itemName;
    map["dateCreated"] = _dateCreated;

    if(_id != null)
    {
      map["id"]= _id;
    }

    return map;

  }

  DoItem.fromMap(Map<String,dynamic> map)
  {
    this._itemName = map["itemName"];
    this._dateCreated = map["dateCreated"];
    this._id = map["id"]; 
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.all(8.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(_itemName,style: new TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.9,
          ),),

              new Container(
            margin: new EdgeInsets.only(top: 5.0),
            child: new Text("Created On $_dateCreated",style: new TextStyle(
              color: Colors.white,
              fontSize: 13.6,
              fontStyle: FontStyle.italic,
            ),),
          )
            ],
          ),
        ],
      ),
    );
  }
}