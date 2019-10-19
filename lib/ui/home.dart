import 'package:flutter/material.dart';
import 'package:todo_app/ui/todo_screen.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("ToDo"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: new ToDoScreen(),
    );
  }
}