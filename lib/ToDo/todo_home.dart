import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_database/ToDo/todo_add.dart';
import 'package:hive_database/ToDo/todo_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ToDoHomePage extends StatefulWidget {
  const ToDoHomePage({Key? key}) : super(key: key);

  @override
  State<ToDoHomePage> createState() => _ToDoHomePageState();
}

class _ToDoHomePageState extends State<ToDoHomePage> {

  Box toDoBox = Hive.box<ToDo>("todo");
  TextEditingController title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddToDoPage()));
        },
      ),
      body: Container(
        padding: const EdgeInsets.all(02),
        child: ValueListenableBuilder(
          valueListenable: toDoBox.listenable(),
          builder: (context, Box box, widget) {
            if (box.isEmpty) {
              return const Center(child: Text("No ToDo Available"));
            } else {
              return ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    ToDo data = box.getAt(index);
                    return InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Title"),
                                content: TextField(
                                  controller: title,
                                  decoration: const InputDecoration(
                                    labelText: "Title",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancel")),
                                  TextButton(
                                      onPressed: () {
                                        ToDo newToDo = ToDo(
                                          title: title.text.trim(),
                                          isCompleted: data.isCompleted,
                                        );
                                        box.putAt(index, newToDo);
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Ok"))
                                ],
                              );
                            });
                      },
                      child: Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(05),
                          title: Text(
                            data.title,
                            style: TextStyle(
                                color: data.isCompleted
                                    ? Colors.lightGreen
                                    : Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                decoration: data.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none),
                          ),
                          leading: const Icon(
                            Icons.notifications_active,
                            color: Colors.purple,
                            size: 20,
                          ),
                          trailing: Wrap(
                            spacing: 12,
                            children: [
                              Checkbox(
                                value: data.isCompleted,
                                onChanged: (value) {
                                  ToDo newToDo = ToDo(
                                      title: data.title, isCompleted: value!);
                                  box.putAt(index, newToDo);
                                },
                              ),
                              IconButton(
                                onPressed: () {
                                  box.deleteAt(index);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "ToDo deleted successfully !")));
                                },
                                icon: const Icon(Icons.delete,color: Colors.redAccent,),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
