import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todoapp_offline/models/Todo.dart';

class TodoListScreen extends StatefulWidget {

  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Todo>('todobox').listenable(),
        builder: (context, Box<Todo> box, _) {
          if (box.values.isEmpty) {
            return const Center(child: Text("No Todo"));
          } else {
            return ListView.builder(
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                var result = box.getAt(index);
                return Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Name: ${result?.title!}",
                                textDirection: TextDirection.ltr,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "isComplete: ${result?.completed!}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                        ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ButtonTheme(
                                    minWidth: 100.0,
                                    height: 50.0,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.black,
                                        side: const BorderSide(
                                          color: Colors.black45,
                                        ),
                                      ),
                                      onPressed: () async {
                                       _editTodo(context, index);
                                      },
                                      child: const Text(
                                        "Edit",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                ButtonTheme(
                                    minWidth: 100.0,
                                    //height: 50.0,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.black,
                                        side: const BorderSide(
                                          color: Colors.black45,
                                        ),
                                      ),
                                      onPressed: () {
                                        _dialogBuilder(context, index);
                                      },
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    )),
                              ],
                            ))
                      ],
                    ));
              },

            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _addNewTodo(context),
      ),
    );
  }

  Future<void> _addNewTodo(BuildContext context) async {
    Box? box = await Hive.openBox<Todo>("todobox");
    if (!context.mounted) return;
    final titleTextController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("New todo"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleTextController,
                  decoration: const InputDecoration(hintText: 'Title'),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if(titleTextController.text.isNotEmpty) {
                        await box.put(
                            DateTime.now().toString(),
                            Todo(
                                title: titleTextController.text,
                                completed: false
                            ));
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      }else{
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Enter title."),
                            )
                        );
                      }
                    },
                    child: const Text("Add")),
              ],
            ),
          );
        });
  }

  Future<void> _editTodo(BuildContext context, int index)  async {
    Box? box = await Hive.openBox<Todo>("todobox");
    if (!context.mounted) return;
    final titleTextController = TextEditingController();
    var result = box.getAt(index);
    showDialog(
        context: context,
        builder: (context) {
          titleTextController.text = result.title;
          return AlertDialog(
            title: const Text("Edit todo"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleTextController,
                  decoration: const InputDecoration(hintText: 'Title'),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if(titleTextController.text.isNotEmpty) {
                        await box.putAt(
                            index,
                            Todo(
                                title: titleTextController.text,
                                completed: false
                            ));
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      }else{
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Enter title."),
                            )
                        );
                      }

                    },
                    child: const Text("Update")),
              ],
            ),
          );
        });
  }

  Future<void> _dialogBuilder(BuildContext context, int index) async {
    Box? box = await Hive.openBox<Todo>("todobox");
    if (!context.mounted) return;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return
          ScaffoldMessenger(child: Builder(builder: (context){
            return Scaffold(
                backgroundColor: Colors.transparent,
                body: AlertDialog(
                  title: const Text('Confirm to delete'),
                  content: const Text(
                      'Are you sure to delete?'

                  ),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),

                    TextButton(
                        style: TextButton.styleFrom(
                        textStyle: Theme
                            .of(context)
                            .textTheme
                            .labelLarge,
                        ),
                        child: const Text('Ok'),
                        onPressed: () async {
                            box.deleteAt(index);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Deleted successfully."),
                                )
                            );
                            Navigator.of(context).pop();
                          }
                    )
                  ],
                ));

          }));
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}