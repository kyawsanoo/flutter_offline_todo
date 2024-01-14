import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todoapp_offline/TodoListScreen.dart';
import 'package:todoapp_offline/models/Todo.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<Todo>("todobox");
  Hive.registerAdapter(TodoAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo app offline',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TodoListScreen(),
    );
  }
}
