// new_todo_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist_riverpod_sqflite/models/todo_class.dart';
import 'package:todolist_riverpod_sqflite/providers/todo_provider.dart';

class NewTodoDialog extends ConsumerStatefulWidget {
  const NewTodoDialog({super.key});

  @override
  ConsumerState<NewTodoDialog> createState() => _NewTodoDialogState();
}

class _NewTodoDialogState extends ConsumerState<NewTodoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("New task"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
              validator: (value) => value!.isEmpty ? 'Required field' : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () => _submitForm(ref),
          child: const Text("ADD"),
        ),
      ],
    );
  }

  void _submitForm(WidgetRef ref) {
    if (_formKey.currentState!.validate()) {
      final newTodo = Todo(
        id: null,
        title: _titleController.text,
        description: _descriptionController.text,
        isCompleted: false,
        creationDate: DateTime.now(),
      );

      ref.read(todoProvider.notifier).addTodo(newTodo);
      if(context.mounted) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Task added")));
    }
  }
}