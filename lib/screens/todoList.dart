import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoflutter/model/Todo.dart';
import 'package:todoflutter/screens/todoDetail.dart';
import 'package:todoflutter/util/dbHelper.dart';
import 'package:todoflutter/util/uiUtils.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoListState();
  }
}

class TodoListState extends State {
  var helper = DbHelper();
  List<Todo> todos;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (todos == null) {
      todos = List<Todo>();
      getData();
    }
    return Scaffold(
      body: todoListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Todo("", "", 3, ""));
        },
        tooltip: "Add new Todo",
        child: new Icon(Icons.add),
      ),
    );
  }

  ListView todoListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        // function iterated for each item of the list
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            // has img and icon
            leading: CircleAvatar(
              backgroundColor: UiUtils.getColor(todos[position].priority),
              child: Text(this.todos[position].priority.toString(),
                  style: TextStyle(color: Colors.white)),
            ),
            title: Text(this.todos[position].title),
            subtitle: Text(this.todos[position].date),
            onTap: () {
              debugPrint("Tapped on " + this.todos[position].id.toString());
              navigateToDetail(todos[position]);
            },
          ),
        );
      },
    );
  }

  void navigateToDetail(Todo todo) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TodoDetail(todo)));

    if (result == true) {
      // update list when return to the todolist page
      getData();
    }
  }

  void getData() {
    final dbFuture = helper.initializeDb();

    dbFuture.then((result) {
      // result = db
      final todosFuture = helper.getTodos();
      todosFuture.then((resultGetTodos) {
        var todoTempList = List<Todo>();
        count = resultGetTodos.length;
        for (int i = 0; i < count; i++) {
          todoTempList.add(Todo.fromObject(resultGetTodos[i]));
          debugPrint(todoTempList[i].title);
        }

        setState(() {
          todos = todoTempList;
          count = count;
          debugPrint("count items is " + count.toString());
        });
      });
    });
  }
}
