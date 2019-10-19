import 'package:flutter/material.dart';
import 'package:todo_app/ui/home.dart';

void main()
{
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "ToDo App",
    home: new Home(),
  ));
}