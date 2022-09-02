import 'package:flutter/material.dart';
import 'package:todo/dbprovider.dart';
import 'models/task.dart';
import 'models/todo.dart';

class TaskCard extends StatefulWidget {
  final Task task;

  const TaskCard({Key? key, required this.task})
      : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  double? progress;

  void _setProgress() async {
    DBProvider dbProvider = DBProvider();
    List<Todo> todos = await dbProvider.getTodos(widget.task.id!);
    int amountOfTrues = todos.map((element) => element.isDone == 1 ? 1 : 0).reduce((value, element) => value + element);
    int amountOfIsDone = todos.length;
    progress = amountOfTrues / amountOfIsDone;
  }

  @override
  Widget build(BuildContext context) {

    _setProgress();

    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.title ?? "Unnamed task",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF202225),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.task.description ?? "Undescribed task...",
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF84878D),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    value: progress ?? 0.0,
                    backgroundColor: const Color(0xFFE7E7E7),
                    color: const Color(0xFF5DD98F),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  progress != null
                      ? "${(progress! * 100).round()}% Done"
                      : "0% Done",
                  style: const TextStyle(
                    color: Color(0xFF84878D),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TodoCheckbox extends StatefulWidget {
  final Todo todo;

  const TodoCheckbox({Key? key, required this.todo}) : super(key: key);

  @override
  State<TodoCheckbox> createState() => _TodoCheckboxState();
}

class _TodoCheckboxState extends State<TodoCheckbox> {
  DBProvider dbProvider = DBProvider();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(widget.todo.isDone == 0) {
          setState(() {
            widget.todo.isDone = 1;
          });
          dbProvider.updateTodo(widget.todo);
        } else {
          setState(() {
            widget.todo.isDone = 0;
          });
          dbProvider.updateTodo(widget.todo);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: widget.todo.isDone == 1 ? const Color(0xFF202225) : Colors.transparent,
                border: widget.todo.isDone == 1
                    ? Border.all(
                        color: const Color(0xFF202225),
                        width: 2,
                      )
                    : Border.all(
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
            Text(
              widget.todo.title ?? "Unnamed ToDo...",
              style: TextStyle(
                fontSize: 20,
                color: widget.todo.isDone == 1 ? const Color(0xFF202225) : const Color(0xFF8A8D92),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
