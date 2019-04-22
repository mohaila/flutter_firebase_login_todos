import 'package:flutter/material.dart';

import '../bloc/disposableprovider.dart';
import '../bloc/todosbloc.dart';
import '../model/todo.dart';

class TodosView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TodosBloc bloc = DisposableProvider.of<TodosBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todos',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: bloc.buildOut,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return _todosList(bloc);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Add todo',
        onPressed: () {
          _showInputDialog(bloc, context);
        },
      ),
    );
  }

  Widget _todosList(TodosBloc bloc) {
    if (bloc.todos.length > 0) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: bloc.todos.length,
        itemBuilder: (BuildContext contex, int index) {
          Todo todo = bloc.todos[index];
          String key = todo.key;
          String subject = todo.subject;
          bool completed = todo.completed;

          return Dismissible(
            key: Key(key),
            background: Container(
              color: Colors.red,
            ),
            onDismissed: (direction) {
              bloc.remove(todo);
            },
            child: ListTile(
              title: Text(
                subject,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              trailing: IconButton(
                  icon: completed
                      ? Icon(
                          Icons.done,
                          color: Colors.green,
                        )
                      : Icon(
                          Icons.done,
                          color: Colors.red,
                        ),
                  onPressed: () {
                    Todo todo = bloc.todos[index];
                    todo.completed = !todo.completed;
                    bloc.update(todo);
                  }),
            ),
          );
        },
      );
    } else {
      return Center(
        child: Text(
          "Add Todo with +",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30.0,
          ),
        ),
      );
    }
  }

  _showInputDialog(TodosBloc bloc, BuildContext context) async {
    TextEditingController controller = TextEditingController();
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Row(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: 'Todo Subject',
                  ),
                ))
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Add'),
                  onPressed: () {
                    Todo todo = Todo(
                      subject: controller.text.toString(),
                      userId: bloc.userId,
                      completed: false,
                    );
                    bloc.create(todo);
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }
}
