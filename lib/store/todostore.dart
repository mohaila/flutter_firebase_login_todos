import 'package:firebase_database/firebase_database.dart';
import '../model/todo.dart';

class TodoStore {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.reference();

  void create(Todo todo) async {
    _databaseRef.child('todos').push().set(todo.toJson());
  }

  void update(Todo todo) async {
    _databaseRef.child('todos').child(todo.key).set(todo.toJson());
  }

  void remove(String id) async {
    _databaseRef.child('todos').child(id).remove();
  }

  void all(String userId) async {
    _databaseRef.child('todos').orderByChild('userId').equalTo(userId);
  }

  Query query(String userId) {
    return _databaseRef.child('todos').orderByChild('userId').equalTo(userId);
  }
}
