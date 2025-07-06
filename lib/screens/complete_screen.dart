import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist_riverpod_sqflite/providers/todo_provider.dart';
import 'package:todolist_riverpod_sqflite/widgets/forms/update_todo_form.dart';
import 'package:todolist_riverpod_sqflite/widgets/todo_full_item.dart';
import 'package:todolist_riverpod_sqflite/models/todo_class.dart';


class CompleteTodoScreen extends ConsumerStatefulWidget {
  const CompleteTodoScreen({super.key});

  @override
  ConsumerState<CompleteTodoScreen> createState() => _CompleteTodoScreenState();
}

class _CompleteTodoScreenState extends ConsumerState<CompleteTodoScreen> {
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
    final completedTodos = ref.watch(completedTodosProvider);
    final searchResults = _searchController.text.isEmpty
        ? completedTodos
        : completedTodos.where((todo) =>
    todo.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
        (todo.description?.toLowerCase().contains(_searchController.text.toLowerCase()) ?? false)
    ).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
                  hintText: "Search completed tasks...",
                  hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.7),
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
                onChanged: (_) => setState(() {}),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Tasks List
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: _searchController.text.isNotEmpty && searchResults.isEmpty
              ? const Center(child: Text("No tasks found", style: TextStyle(color: Colors.grey)))
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
      color: Colors.green.withValues(alpha: 0.3),
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
                      onPressed: () => todoNotifier.toggleTodoCompletion(todo.id!, false),
                      icon: const Icon(Icons.undo),
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
              children: [
                Text(
                  todo.creationDate.toIso8601String(),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TodoItem(todo: todo),
          ),
        ),
      ),
    );
  }
}