import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do/database_helper.dart';
import 'package:to_do/models/task.dart';
import 'package:to_do/models/todo.dart';
import 'package:to_do/widgets.dart';

class TaskPage extends StatefulWidget {
  final Task task;

  TaskPage({ @required this.task});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

  
  DatabaseHelper _dbHelper = DatabaseHelper();

  String _taskTitle = "";
  String _taskDescription = "";
  int _taskId = 0;

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool _contentVisible = false;

  @override
  void initState() {
    if(widget.task != null) {
      _contentVisible = true;
      _taskTitle = widget.task.title;
      _taskDescription = widget.task.description;
      _taskId = widget.task.id;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                children: [
                  //TITLE TASK
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      bottom: 10
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(Icons.arrow_back, color: Colors.black)),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _titleFocus,
                            controller: TextEditingController()..text = _taskTitle,
                            onSubmitted: (value) async {
                              if(value != "") {
                                if(widget.task == null) {
                                  Task _newTask = Task(
                                    title: value,
                                  );
                                  _taskId = await _dbHelper.insertTask(_newTask);
                                  setState(() {
                                    _contentVisible = true;
                                    _taskTitle = value;
                                  });
                                  await _dbHelper.updateTaskTitle(_taskId, value);
                                }
                                _descriptionFocus.requestFocus();
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Enter Task Title",
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF211551)

                            )
                          )
                        )
                      ]
                    ),
                  ),
                  //DESCRIPTION TASK
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12.0
                      ),
                      child: TextField(
                        focusNode: _descriptionFocus,
                        onSubmitted: (value) async {
                          if(value != '') {
                            if(_taskId != 0) {
                              await _dbHelper.updateTaskDescription(_taskId, value);
                              _taskDescription = value;
                            }
                          }
                          _todoFocus.requestFocus();
                        },
                        controller: TextEditingController()..text = _taskDescription,
                        decoration: InputDecoration(
                          hintText: "Enter Description for the task...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                          )
                        )
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getToDo(_taskId),
                      builder: (context, snapshot) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  //Switch the todoo true
                                  if(snapshot.data[index].isDone == 0){
                                    await _dbHelper.updateTodoDone(snapshot.data[index].id, 1);
                                  } else {
                                    await _dbHelper.updateTodoDone(snapshot.data[index].id, 0);
                                  }
                                  setState(() {});
                                  print("TODO Done ${snapshot.data[index].isDone}");
                                },
                                child: TodoWidget(
                                  text: snapshot.data[index].title,
                                  isDone: snapshot.data[index].isDone == 0 ? false : true
                                ),
                              );
                            }
                          ),
                        );
                      }
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 25,
                                  height: 25,
                                  margin: EdgeInsets.only(
                                    right: 16
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(
                                      color: Color(0xFF86829D),
                                      width: 1.5
                                    )
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Icon(Icons.check, color: Colors.white, size: 18),
                                  )
                                ),
                                Expanded(
                                  child: TextField(
                                    focusNode: _todoFocus,
                                    controller: TextEditingController()..text = "",
                                    onSubmitted: (value) async {
                                      if(value != "") {
                                        if(_taskId != null) {
                                          ToDo _newToDo = ToDo(
                                            title: value,
                                            isDone: 0,
                                            taskId: _taskId,
                                          );
                                          await _dbHelper.insertToDo(_newToDo);
                                          setState(() {});
                                          _todoFocus.requestFocus();
                                        }
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Enter Todo Item...",
                                      border: InputBorder.none
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: _contentVisible,
                child: Positioned(
                  bottom: 20.0,
                  right: 20.0,
                  child: GestureDetector(
                    onTap: () async {
                      if(_taskId != 0) {
                        await _dbHelper.deleteTask(_taskId);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFFE3577)
                      ),
                      child: Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                      )
                    ),
                  ),
                ),
              )
            ],
          )
        ),
      )
    );
  }
}