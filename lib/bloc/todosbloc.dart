import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'disposable.dart';
import '../store/todostore.dart';
import '../model/todo.dart';
import '../service/loginservice.dart';

class TodosBloc extends Disposable {
  final _buildController = StreamController<bool>();
  final TodoStore _store = TodoStore();
  StreamSubscription<Event> _addedSubscription;
  StreamSubscription<Event> _updatededSubscription;
  StreamSubscription<Event> _removedSubscription;
  String _userId;
  Query _query;
  List<Todo> _todos = List<Todo>();

  get _build => _buildController.sink;

  Stream<bool> get buildOut => _buildController.stream;

  List<Todo> get todos => _todos;

  String get userId => _userId;

  TodosBloc() {
    LoginService().getCurrentUser().then((FirebaseUser user) {
      _userId = user.uid;
      _query = _store.query(_userId);
      _addedSubscription = _query.onChildAdded.listen(_onAdded);
      _updatededSubscription = _query.onChildChanged.listen(_onUpdated);
      _removedSubscription = _query.onChildRemoved.listen(_onRemoved);
    });
  }

  void create(Todo todo) async {
    _store.create(todo);
  }

  void update(Todo todo) async {
    _store.update(todo);
  }

  void remove(Todo todo) async {
    _store.remove(todo.key);
  }

  void all() async {}

  void _onAdded(Event event) {
    _todos.add(Todo.fromSnapshot(event.snapshot));

    _build.add(true);
  }

  void _onUpdated(Event event) {
    final old = _todos.singleWhere((Todo todo) {
      return todo.key == event.snapshot.key;
    });
    final index = _todos.indexOf(old);
    _todos[index] = Todo.fromSnapshot(event.snapshot);

    _build.add(true);
  }

  void _onRemoved(Event event) {
    final old = _todos.singleWhere((Todo todo) {
      return todo.key == event.snapshot.key;
    });
    final index = _todos.indexOf(old);
    _todos.removeAt(index);

    _build.add(true);
  }

  @override
  void dispose() {
    _buildController.close();
    _addedSubscription.cancel();
    _updatededSubscription.cancel();
    _removedSubscription.cancel();
  }
}
