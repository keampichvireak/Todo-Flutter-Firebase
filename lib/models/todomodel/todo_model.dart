// enum Level {
//   Optional,
//   Important,
//   Mandatory,
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String task;
  bool isDone;
  Timestamp createdOn;
  Timestamp updatedOn;
  String? userId;
  String description;
  String level;

  Todo({
    required this.task,
    required this.isDone,
    required this.createdOn,
    required this.updatedOn,
    required this.userId,
    required this.description,
    required this.level,
  });

  Todo.fromJson(Map<String, dynamic> json)
      : this(
          task: json['task'] as String,
          isDone: json['isDone'] as bool,
          createdOn: json['createdOn'] as Timestamp,
          updatedOn: json['updatedOn'] as Timestamp,
          userId: json['userId'] as String,
          description: json['description'] as String,
          level: json['level'] as String? ?? '',
        );

  Todo copyWith({
    String? task,
    bool? isDone,
    Timestamp? createdOn,
    Timestamp? updatedOn,
    String? level,
  }) {
    return Todo(
      task: task ?? this.task,
      isDone: isDone ?? this.isDone,
      createdOn: createdOn ?? this.createdOn,
      updatedOn: updatedOn ?? this.updatedOn,
      userId: userId,
      description: description,
      level: level ?? this.level,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'task': task,
      'isDone': isDone,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
      'userId': userId,
      'description': description,
      'level': level,
    };
  }
}
