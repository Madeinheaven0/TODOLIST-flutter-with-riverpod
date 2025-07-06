import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist_riverpod_sqflite/providers/theme_provider.dart';
import 'package:todolist_riverpod_sqflite/screens/home_screen.dart';
import 'package:todolist_riverpod_sqflite/widgets/forms/new_todo_form.dart';

class TodoApp extends ConsumerWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      home: const HomeScreen()
    );
  }
}