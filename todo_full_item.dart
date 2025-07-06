import 'package:flutter/material.dart';
import 'package:todolist_riverpod_sqflite/models/todo_class.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  const TodoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(todo.title),
      content: Padding(
          padding: EdgeInsets.all(12),
          child: Center(
            child: Column(
              children: [
                Text("Title: ${todo.title}"),
                const SizedBox(height: 10),
                Text("Description: ${todo.description}"),
                const SizedBox(height: 10),
                Text("Create at: ${todo.creationDate.toIso8601String()}"),
                const SizedBox(height: 10),
                if(todo.isCompleted) Text("State: Completed") else Text("State: Uncompleted")
              ],
            ),
          ),
      ),
      actions: [
        ElevatedButton(
            onPressed: ()=> Navigator.of(context).pop(),
            child: Text("OK")
        )
      ],
    );
  }
}