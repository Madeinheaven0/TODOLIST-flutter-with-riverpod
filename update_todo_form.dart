import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist_riverpod_sqflite/models/todo_class.dart';
import 'package:todolist_riverpod_sqflite/providers/todo_provider.dart';

class UpdateTodoDialog extends ConsumerStatefulWidget {
  final Todo todoTask;
  final WidgetRef ref;
  const UpdateTodoDialog({super.key, required this.todoTask, required this.ref});

  @override
  ConsumerState<UpdateTodoDialog> createState()=> _UpdateStateTodoDialog();
}

class _UpdateStateTodoDialog extends ConsumerState<UpdateTodoDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Update Task"),
      content: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                maxLines: 1,
                maxLength: 25,
                decoration: const InputDecoration(
                  hintMaxLines: 1,
                  hintText: "New title",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  border: OutlineInputBorder(),
                  filled: true,
                  focusColor: Colors.blue
                ),
              ),
              const SizedBox(height: 10,),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                maxLength: 300,
                decoration: const InputDecoration(
                  hintMaxLines: 1,
                  hintText: "New description",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  border: OutlineInputBorder()
                ),
              )
            ],
          )
      ),
      actions: [
        ElevatedButton(
            onPressed: () async {
              if(_titleController.text.isEmpty && _descriptionController.text.isEmpty){
                Navigator.of(context).pop();
              }else {
                Todo newTodo = widget.todoTask.copyWith(
                  title: _titleController.text.isNotEmpty ? _titleController.text : widget.todoTask.title,
                  description: _descriptionController.text.isNotEmpty ? _descriptionController.text : widget.todoTask.description,
                );
                ref.read(todoProvider.notifier).updateTodo(newTodo);
                if (context.mounted) Navigator.of(context).pop();
                if (_titleController.text.isNotEmpty &&  _descriptionController.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Title and description updated')));
                } else if (_titleController.text.isNotEmpty &&  _descriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Title updated')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Description updated')));
                }
              }
            },
            child: Text("Update Task")
        ),
        ElevatedButton(
            onPressed: ()=> Navigator.of(context).pop(),
            child: Text("Cancel")
        )
      ],
    );
  }
}