import 'package:authflutter/models/todomodel/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const String TODO_COLLECTION_REF = "todos";

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _todosRef;

  DatabaseService() {
    // Initialize the todos reference for the authenticated user
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    _todosRef = _firestore
        .collection(TODO_COLLECTION_REF)
        .doc(userId)
        .collection('todos')
        .withConverter<Todo>(
            fromFirestore: (snapshots, _) => Todo.fromJson(
                  snapshots.data()!,
                ),
            toFirestore: (todo, _) => todo.toJson());
  }

  Stream<QuerySnapshot> getTodos() {
    return _todosRef.snapshots();
  }

  void addTodo(Todo todo) async {
    _todosRef.add(todo);
  }

  void updateTodo(String todoId, Todo todo) {
    _todosRef.doc(todoId).update(todo.toJson());
  }

  void deleteTodo(String todoId) {
    _todosRef.doc(todoId).delete();
  }

  Stream<QuerySnapshot> getTodosByCategory(String category) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      // Handle the case where the user is not authenticated
      return Stream.empty();
    }

    return _firestore
        .collection(TODO_COLLECTION_REF)
        .doc(userId)
        .collection('todos')
        .where('level', isEqualTo: category)
        .withConverter<Todo>(
          fromFirestore: (snapshots, _) => Todo.fromJson(snapshots.data()!),
          toFirestore: (todo, _) => todo.toJson(),
        )
        .snapshots();
  }
}
