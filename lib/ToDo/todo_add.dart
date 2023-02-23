import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_database/ToDo/todo_model.dart';

class AddToDoPage extends StatefulWidget {
  const AddToDoPage({Key? key}) : super(key: key);

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {

  Box box = Hive.box<ToDo>("todo");

  TextEditingController title = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add ToDo"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
            controller: title,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
           ),
            const SizedBox(height: 20,),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(onPressed: (){
                if(title.text.isNotEmpty){
                  ToDo newToDo = ToDo(
                      title: title.text.trim(),
                      isCompleted: false,
                  );
                  box.add(newToDo);
                  Navigator.pop(context);
                }
              },
                  child: const Text("Submit")),
            ),
          ],
        ),
      ),
    );
  }
}
