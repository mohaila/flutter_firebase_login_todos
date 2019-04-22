import 'package:flutter/material.dart';

import 'bloc/disposableprovider.dart';
import 'bloc/loginbloc.dart';
import 'bloc/todosbloc.dart';
import 'view/loginview.dart';
import 'view/todosview.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: <String, WidgetBuilder>{
        '/todos': (context) => DisposableProvider<TodosBloc>(
              bloc: TodosBloc(),
              child: TodosView(),
            ),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DisposableProvider<LoginBloc>(
        child: LoginView(),
        bloc: LoginBloc(),
      ),
    );
  }
}
