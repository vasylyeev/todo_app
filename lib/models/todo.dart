class Todo {
  int? id;
  int? taskId;
  int? isDone;
  String? title;

  Todo({this.id, this.taskId, this.isDone, this.title});

  Todo.fromMap(Map<String, dynamic> item)
      : id = item["id"],
        taskId = item["taskId"],
        isDone = item["isDone"],
        title = item["title"];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'isDone': isDone,
      'title': title,
    };
  }
}
