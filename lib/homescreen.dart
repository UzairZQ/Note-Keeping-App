import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_database/models/boxes.dart';
import 'package:hive_database/models/notes_model.dart';
import 'package:hive_flutter/adapters.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive Database'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
          valueListenable: Boxes.getData().listenable(),
          builder: (context, box, _) {
            var data = box.values.toList().cast<NotesModel>();
            return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                data[index].title.toString(),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  _editDialogue(
                                    data[index],
                                    data[index].title.toString(),
                                    data[index].description.toString(),
                                  );
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              InkWell(
                                onTap: () {
                                  _delete(data[index]);
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                          Text(data[index].description.toString(),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w300)),
                        ],
                      ),
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showDialogue();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _delete(NotesModel notesModel) {
    notesModel.delete();
  }

  Future<void> _showDialogue() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            icon: Icon(Icons.notes),
            title: Text('Add Notes'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      hintText: 'Enter Title',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      hintText: 'Enter Description',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final data = NotesModel(
                      description: descriptionController.text,
                      title: titleController.text);
                  final box = Boxes.getData();
                  box.add(data);
                  // data.save();
                  titleController.clear();
                  descriptionController.clear();

                  print(data.title + data.description);
                  Navigator.pop(context);
                },
                child: Text('Add'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          );
        });
  }

  Future<void> _editDialogue(
      NotesModel notesModel, String title, String description) {
    titleController.text = title;
    descriptionController.text = description;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            icon: Icon(Icons.notes),
            title: Text('Edit Notes'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      hintText: 'Enter Title',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      hintText: 'Enter Description',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  notesModel.title = titleController.text;
                  notesModel.description = descriptionController.text;
                  notesModel.save();
                  titleController.clear();
                  descriptionController.clear();
                  Navigator.pop(context);
                },
                child: Text('Edit'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          );
        });
  }
}
