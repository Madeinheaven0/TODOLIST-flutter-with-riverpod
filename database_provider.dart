import 'package:riverpod/riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist_riverpod_sqflite/models/database_class.dart';

// The provider of the database's instance
final databaseProvider = Provider<TodoDatabase>((ref)=> TodoDatabase.instance);

// The provider of the instance of the database
final databaseInitializerProvider = FutureProvider<Database>((ref) async {
  final todoDatabase = ref.read(databaseProvider);
  return todoDatabase.database;
});