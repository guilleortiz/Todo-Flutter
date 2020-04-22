import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoflutter/model/Todo.dart';
import 'package:todoflutter/util/dbHelper.dart';
import 'package:todoflutter/util/uiUtils.dart';

var helper = DbHelper();
final List<String> choices = const <String>[
  "Save Todo & back",
  "Delet Todo",
  "Back to List"
];

const mnuSave = "Save Todo & back";
const mnuDelete = "Delet Todo";
const mnuBack = "Back to List";

class TodoDetail extends StatefulWidget {
  final Todo todo;

  TodoDetail(this.todo);

  @override
  State<StatefulWidget> createState() => TodoDetailState(todo);
}

class TodoDetailState extends State {
  Todo todo;

  TodoDetailState(this.todo);

  var _priorities = [
    "High",
    "Medium",
    "Low",
  ];
  var _priority = "Low";

  var titleControler = TextEditingController();
  var desciprtionControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleControler.text = todo.title;
    desciprtionControler.text = todo.description;
    var textStyle = Theme.of(context).textTheme.title;

    return new Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: new Text(todo.title),
        backgroundColor: UiUtils.getColor(todo.priority),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: select,
            itemBuilder: (BuildContext context) {
              return choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Padding(
          padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: titleControler,
                      style: textStyle,
                      onChanged: (value) => this.updateTitle(),
                      decoration: InputDecoration(
                          labelText: "Title",
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: TextField(
                          controller: desciprtionControler,
                          style: textStyle,
                          onChanged: (value) => this.updateDescription(),
                          decoration: InputDecoration(
                              labelText: "Description",
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                        )),
                    ListTile(
                        title: DropdownButton<String>(
                      items: _priorities.map((String mapValue) {
                        return DropdownMenuItem<String>(
                          value: mapValue,
                          child: Text(mapValue),
                        );
                      }).toList(),
                      style: textStyle,
                      value: retievePriority(todo.priority),
                      onChanged: (value) => updatePriority(value),
                    )),
                  ])
            ],
          )),
    );
  }

  void _ondropDownChange(String value) {
    debugPrint("changed to value: " + value);
  }

  void select(String value) async {
    int result;
    switch (value) {
      case mnuSave:
        save();
        break;
      case mnuDelete:
        Navigator.pop(context, true);

        if (todo.id == null) {
          return;
        }
        result = await helper.deleteTodo(todo.id);

        if (result != 0) {
          AlertDialog alertDialog = AlertDialog(
            title: Text("Delete Todo"),
            content: Text("The Todo Has been deleted"),
          );
          showDialog(context: context, builder: (_) => alertDialog);
        }
        break;
      case mnuBack:
        Navigator.pop(context, true);
        break;
    }
  }

  void save() {
    todo.date = new DateFormat.yMd().format(DateTime.now());
    if (todo.id != null) {
      helper.updateTodo(todo);
    } else {
      helper.insertTodo(todo);
    }
    Navigator.pop(context, true);
  }

  void updatePriority(String value) {
    switch (value) {
      case "High":
        todo.priority = 1;
        break;
      case "Medium":
        todo.priority = 2;
        break;
      case "Low":
        todo.priority = 3;
        break;
    }
    setState(() {
      _priority = value;
    });
  }

  String retievePriority(int value) {
    return _priorities[value - 1];
  }

  void updateTitle() {
    todo.title = titleControler.text;
  }

  void updateDescription() {
    todo.description = desciprtionControler.text;
  }
}
