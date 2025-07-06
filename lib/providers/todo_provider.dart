import 'package:riverpod/riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist_riverpod_sqflite/models/todo_class.dart';
import 'package:todolist_riverpod_sqflite/providers/database_provider.dart';

// The database of the list of data
final todoProvider = StateNotifierProvider<TodoNotifier, AsyncValue<List<Todo>>>((ref) {
  return TodoNotifier(ref);
});


// The class TodoNotifier who manage all the state and the CRUD operations of
// the database
class TodoNotifier extends StateNotifier<AsyncValue<List<Todo>>> {
  final Ref ref;

  // The initial state of the value is loading
  TodoNotifier(this.ref) : super(const AsyncValue.loading()) { // when we are in the loading state, we _init
    _init();
  }

  // _init function
  Future<void> _init() async {
    try { // We import the database
      final db = await ref.read(databaseInitializerProvider.future); // we take the database of the FutureProvider
      await _loadTodos(db);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> _loadTodos(Database db) async {
    try {
      state = const AsyncValue.loading(); // We are in loading mode
      final todos = await db.query('Todos', orderBy: 'creationDate DESC');
      final todoList = todos.map(Todo.fromMap).toList();
      state = AsyncValue.data(todoList); // we put the data fetched and we go in the state data
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addTodo(Todo todo) async {
    try {
      final db = await ref.read(databaseInitializerProvider.future);
      await db.insert('Todos', todo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      await _loadTodos(db); // We refresh the AsyncValue.data
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      final db = await ref.read(databaseInitializerProvider.future);
      await db.update(
        'Todos',
        todo.toMap(),
        where: 'id = ?',
        whereArgs: [todo.id],
      );
      await _loadTodos(db);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      final db = await ref.read(databaseInitializerProvider.future);
      await db.delete(
        'Todos',
        where: 'id = ?',
        whereArgs: [id],
      );
      await _loadTodos(db);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> toggleTodoCompletion(int id, bool isCompleted) async {
    try {
      final db = await ref.read(databaseInitializerProvider.future);
      await db.rawUpdate(
        'UPDATE Todos SET isCompleted = ? WHERE id = ?',
        [isCompleted ? 1 : 0, id],
      );
      await _loadTodos(db);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}


final completedTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todoProvider).value ?? [];
  return todos.where((todo) => todo.isCompleted).toList();
});

final uncompletedTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todoProvider).value ?? [];
  return todos.where((todo) => !todo.isCompleted).toList();
});


final searchTodoProvider = Provider.family<List<Todo>, String>((ref, query) {
  // Prend toujours les données FRÂCHES
  final todos = ref.watch(todoProvider.select((state) => state.value ?? []));

  if (query.isEmpty) return todos;

  return todos.where((todo) =>
      todo.title.toLowerCase().contains(query.toLowerCase())
  ).toList();
});
