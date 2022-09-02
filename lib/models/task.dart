import 'package:todo/dbprovider.dart';

class Task {
  int? id;
  String? title;
  String? description;
  DBProvider dbProvider = DBProvider();

  Task({this.id, this.title, this.description});

  Task.fromMap(Map<String, dynamic> item)
      : id = item["id"],
        title = item["title"],
        description = item["description"];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}
