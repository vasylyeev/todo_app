import 'package:flutter/material.dart';
import 'package:todo/dbprovider.dart';
import 'package:todo/pages/taskpage.dart';
import 'package:todo/widgets.dart';
import '../models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBProvider dbProvider = DBProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEFF2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "My tasks",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF202225),
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const SizedBox(height: 16),
                  Expanded(
                    child: FutureBuilder(
                      future: dbProvider.getTasks(),
                      builder: (context, AsyncSnapshot<List<Task>> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Error');
                        }
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TaskPage(
                                        task: snapshot.data![index],
                                        taskId: snapshot.data![index].id,
                                      ),
                                    ),
                                  ).then((context) {
                                    setState(() {});
                                  });
                                },
                                child: TaskCard(
                                  task: snapshot.data![index],
                                ),
                              );
                            },
                          );
                        } else {
                          return const Scaffold(
                            body: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
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
                    Task newTask = Task();
                    int newTaskId = await dbProvider.insertTask(newTask);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskPage(
                          task: newTask,
                          taskId: newTaskId,
                        ),
                      ),
                    ).then((context) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF202225),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 45,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
