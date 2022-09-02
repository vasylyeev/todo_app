import 'package:flutter/material.dart';
import 'package:todo/dbprovider.dart';
import '../models/task.dart';
import '../models/todo.dart';
import '../widgets.dart';

class TaskPage extends StatefulWidget {
  final Task task;
  int? taskId = 0;

  TaskPage({Key? key, required this.task, this.taskId}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final DBProvider _dbProvider = DBProvider();
  String? _currentTitle;
  String? _currentDescription;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  void _updateTitle() async {
    widget.task.title = titleController.text;
    await _dbProvider.updateTask(widget.task);
  }

  void _updateDescription() async {
    widget.task.description = descriptionController.text;
    await _dbProvider.updateTask(widget.task);
  }

  @override
  void initState() {
    widget.task.id = widget.taskId;
    titleController.addListener(_updateTitle);
    descriptionController.addListener(_updateDescription);
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    titleController.text = widget.task.title != null ? widget.task.title! : '';
    descriptionController.text = widget.task.description != null ? widget.task.description! : '';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleController,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF202225),
                      letterSpacing: -0.5,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Add title...',
                    ),
                  ),
                  TextField(
                    controller: descriptionController,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFF84878D),
                      letterSpacing: -0.5,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Add description...',
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: FutureBuilder(
                      future: _dbProvider.getTodos(widget.taskId!),
                      builder: (context, AsyncSnapshot<List<Todo>> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            return TodoCheckbox(
                              todo: snapshot.data![index],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () async {
                    await _dbProvider.deleteTask(widget.task.id!);
                    await _dbProvider.deleteTodo(widget.task.id!);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFED4A4A),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: const Color(0xFF8A8D92),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        onSubmitted: (todoTitle) async {
                          Todo newTodo = Todo(
                            taskId: widget.taskId,
                            title: todoTitle,
                            isDone: 0,
                          );
                          await _dbProvider.insertTodo(newTodo);
                          setState(() {});
                        },
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xFF84878D),
                          letterSpacing: -0.5,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Add todo...',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
