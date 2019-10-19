import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todo_app/model/do_item.dart';
import 'package:todo_app/util/database_client.dart';
import 'package:todo_app/util/date_formatter.dart';

class ToDoScreen extends StatefulWidget {
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {

  String _time = "Not set";
  String timeUpdate = "Not Set";

  final TextEditingController _textEditingController =
      new TextEditingController();
  var db = new DatabaseHelper();
  final List<DoItem> _itemList = <DoItem>[];
   List<String> _timeList = <String>[];

  @override
  void initState() {
    super.initState();
    _readDoList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              
              padding: new EdgeInsets.all(8.0),
              reverse: false,
              itemCount: _itemList.length,
              itemBuilder: (_, int index) {
                return new Card(
                  elevation: 40.0,
                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(26.0)),
                  color: Colors.purple,
                  child: new ListTile(
                    title: _itemList[index],
                    onLongPress: () => _updateItem(_itemList[index], index),
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30.0,
                      child: Text('${_timeList.elementAt(index)}',style: TextStyle(color: Colors.black),),
                    ),
                    trailing: new Listener(
                      key: new Key(_itemList[index].itemName),
                      child: new Icon(
                        Icons.remove_circle,
                        size: 25.7,
                        color: Colors.white,
                      ),
                      onPointerDown: (pointerEvent) =>
                          _deleteDo(_itemList[index].id, index),
                    ),
                  ),
                );
              },
            ),
          ),
          new Divider(
            height: 1.0,
          )
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        elevation: 50.0,
        tooltip: "Add Note",
        backgroundColor: Colors.red,
        child: new ListTile(
          title: new Icon(Icons.add),
        ),
        onPressed: _showFormDialog,
      ),
    );
  }

  void _showFormDialog() {
    var alert = new AlertDialog(
      title: new Text("Add Item"),
      content: new Column(
        children: <Widget>[
          new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              controller: _textEditingController,
              autofocus: true,
              decoration: new InputDecoration(
                labelText: "Item",
                hintText: "eg. Buy Groceries",
                icon: new Icon(Icons.note_add),
              ),
            ),
          ),
        ],
      ),

      Padding(padding: EdgeInsets.only(top: 30.5)),

      RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0,
                onPressed: () {
                  DatePicker.showTimePicker(context,
                  
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true, onConfirm: (time) {
                    print('confirm $time');
                    _time = '${time.hour} : ${time.minute}';
                    timeUpdate = _time;
                    setState(() {
                    timeUpdate = _time;
                    });
                  },currentTime: DateTime.now(), locale: LocaleType.en,
                  onChanged: (time){
                    timeUpdate = '${time.hour} : ${time.minute}';
                  },);
                  setState(() {});
                  
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  size: 18.0,
                                  color: Colors.teal,
                                ),
                                Text(
                                  " $timeUpdate",
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "  Change",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              )

        ],
        mainAxisSize: MainAxisSize.min,
      ) ,
      
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            _handleSubmit(_textEditingController.text);
            _textEditingController.clear();
          },
          child: new Text("Save"),
        ),
        new FlatButton(
          onPressed: () => Navigator.pop(context),
          child: new Text("Cancel"),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmit(String text) async {
    _textEditingController.clear();

    DoItem doItem = new DoItem(text, dateFormatted());
    int savedItemId = await db.saveItem(doItem);
    DoItem addedItem = await db.getItem(savedItemId);

    setState(() {
      _itemList.insert(0, addedItem);
      _timeList.insert(0, timeUpdate);
    });

    print("Item Saved Id : $savedItemId");
    Navigator.pop(context);
  }

  _readDoList() async {
    List items = await db.getItems();
    items.forEach((item) {
      // DoItem doItem = new DoItem.map(item);
      setState(() {
        _itemList.add(DoItem.map(item));
        _timeList.add("$timeUpdate");
      });
      // print("Db items : ${doItem.itemName}");
    });
  }

  _deleteDo(int id, int index) async {
    debugPrint("Deleted Item!");
    

    await db.deleteItem(id);
    setState(() {
      
      _itemList.removeAt(index);
    });
  }

  _updateItem(DoItem item, int index) {
    var alert = new AlertDialog(
      title: new Text("Update Item"),
      content: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              controller: _textEditingController,
              autofocus: false,
              decoration: new InputDecoration(
                labelText: "Item",
                hintText:  "Buy Stuff",
                icon: new Icon(Icons.update),
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () async {
            DoItem updatedItem = DoItem.fromMap(
              {"itemName":_textEditingController.text,
              "dateCreated": dateFormatted(),
              "id":item.id});
              _handleSubmitUpdate(index,item);
              await db.updateItem(updatedItem);
              setState(() {
               _readDoList(); 
              });
                        },
                        child: new Text("Update!"),
                      ),
                      new FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: new Text("Cancel")
                      )
                    ],
                  );
                  showDialog(context: context,builder: (_){
                    return alert;
                  });
                }
              
                void _handleSubmitUpdate(int index, DoItem item) {
                  setState(() {
                   _itemList.removeWhere((element) {
                     return _itemList[index].itemName == item.itemName;
                   });
                  });
                  Navigator.pop(context);
                }
}


