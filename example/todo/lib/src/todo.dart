// To parse this JSON data, do
//
//     final todo = todoFromJson(jsonString);

import 'dart:convert';

Todo todoFromJson(String str) => Todo.fromJson(json.decode(str));

String todoToJson(Todo data) => json.encode(data.toJson());

class Todo {
  List<TodoElement> todos;
  int total;
  int skip;
  int limit;

  Todo({
    required this.todos,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    todos: List<TodoElement>.from(
      json["todos"].map((x) => TodoElement.fromJson(x)),
    ),
    total: json["total"],
    skip: json["skip"],
    limit: json["limit"],
  );

  Map<String, dynamic> toJson() => {
    "todos": List<dynamic>.from(todos.map((x) => x.toJson())),
    "total": total,
    "skip": skip,
    "limit": limit,
  };
}

class TodoElement {
  int id;
  String todo;
  bool completed;
  int userId;

  TodoElement({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  factory TodoElement.fromJson(Map<String, dynamic> json) => TodoElement(
    id: json["id"],
    todo: json["todo"],
    completed: json["completed"],
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "todo": todo,
    "completed": completed,
    "userId": userId,
  };
}
