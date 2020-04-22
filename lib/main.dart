import 'package:flutter/material.dart';
import 'package:todoflutter/screens/todoList.dart';
import 'package:todoflutter/util/dbHelper.dart';

import 'model/Todo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    List<Todo> todos = List<Todo>();

    DbHelper helper = DbHelper();
    helper.initializeDb().then((result) => helper.getTodos().then((result) {
          var kk = result;
          todos = kk;
          debugPrint(todos.length.toString());
        }));

    return MaterialApp(
      title: 'Todos',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(title: 'Todos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: TodoList(),
    );
  }
}
