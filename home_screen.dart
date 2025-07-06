import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist_riverpod_sqflite/providers/theme_provider.dart';
import 'package:todolist_riverpod_sqflite/screens/all_todo.dart';
import 'package:todolist_riverpod_sqflite/screens/complete_screen.dart';
import 'package:todolist_riverpod_sqflite/screens/uncomplete_screen.dart';
import 'package:todolist_riverpod_sqflite/widgets/forms/new_todo_form.dart';


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("TODOLIST"),
            bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.home)),
                  Tab(icon: Icon(Icons.check)),
                  Tab(icon: Icon(Icons.radio_button_unchecked))
                ],
            ),
          ),
          body: const TabBarView(
              children: [
                const AllTodos(),
                const CompleteTodoScreen(),
                const UncompleteTodoScreen()
              ]
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                  onPressed: () => _showAddDialog(context, ref),
                  child: const Icon(Icons.add),
              ),
              const SizedBox(height: 3),
              FloatingActionButton(
                  onPressed:  () {
                    final currentTheme = ref.read(themeProvider);
                    ref.read(themeProvider.notifier).state =
                    currentTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
                  },
                child: Icon(ref.watch(themeProvider) == ThemeMode.light
                    ? Icons.light_mode
                    : Icons.dark_mode),
              )
            ],
          )
        ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const NewTodoDialog(),
    );
  }
}