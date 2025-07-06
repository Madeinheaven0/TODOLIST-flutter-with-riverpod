import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist_riverpod_sqflite/models/todo_class.dart';
import 'package:todolist_riverpod_sqflite/providers/todo_provider.dart';
import 'package:todolist_riverpod_sqflite/widgets/forms/update_todo_form.dart';
import 'package:todolist_riverpod_sqflite/widgets/todo_full_item.dart';

class AllTodos extends ConsumerStatefulWidget {
  const AllTodos({super.key});

  @override
  ConsumerState<AllTodos> createState() => _AllTodosState();
}

class _AllTodosState extends ConsumerState<AllTodos> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todoProvider).value ?? [];
    final searchResults = _searchController.text.isEmpty
        ? todos
        : ref.watch(searchTodoProvider(_searchController.text));

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search tasks...",
                  hintStyle: TextStyle(
                    color: Colors.grey.withValues(alpha: 0.7),
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700,
                  ),
                  suffixIcon: _searchController.text.isEmpty
                      ? const Icon(Icons.search)
                      : IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (text) {
                  // Force l'actualisation
                  ref.invalidate(searchTodoProvider);
                  setState(() {});
                },
              ),
            ),
          ),
        ),

        // Tasks List
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: _searchController.text.isNotEmpty && searchResults.isEmpty
              ? const Center(child: Text("No tasks found"))
              : ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) => _buildTodoItem(searchResults[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildTodoItem(Todo todo) {
    final todoNotifier = ref.read(todoProvider.notifier);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      color: todo.isCompleted
          ? Colors.green.withValues(alpha: 0.3)
          : Colors.red.withValues(alpha: 0.3),
      child: ListTile(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  todo.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UpdateTodoDialog(todoTask: todo, ref: ref),
                        ),
                      ),
                      icon: const Icon(Icons.edit),
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      onPressed: () => todoNotifier.toggleTodoCompletion(todo.id!, !todo.isCompleted),
                      icon: Icon(
                        todo.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                      ),
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      onPressed: () {
                        todoNotifier.deleteTodo(todo.id!);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Task deleted")),
                          );
                        }
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text(todo.creationDate.toIso8601String())],
            ),
          ],
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TodoItem(todo: todo),
          ),
        ),
        onLongPress: () {
          todoNotifier.deleteTodo(todo.id!);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Task deleted")),
            );
          }
        },
      ),
    );
  }
}