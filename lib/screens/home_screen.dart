import 'package:flutter/material.dart';
import '../models/task.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // sekarang pakai List<Task>, bukan List<String>
  List<Task> tasks = [
    Task(title: "Belajar Flutter", description: "Mengerjakan project PPB"),
    Task(title: "Kerjakan Tugas PPB"),
    Task(title: "Istirahat"),
  ];

  Future<void> _navigateToAddTask() async {
    final newTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTaskScreen(),
      ),
    );

    if (newTask != null) {
      setState(() {
        tasks.add(newTask);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My To-Do List"),
        centerTitle: true,
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTask,
        child: const Icon(Icons.add),
      ),

      body: tasks.isEmpty
          ? const Center(
              child: Text(
                "Belum ada tugas",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return Card(
                  child: ListTile(
                    leading: Icon(
                      task.isCompleted
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: task.description != null || task.dueDate != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (task.description != null)
                                Text(task.description!),
                              if (task.dueDate != null)
                                Text(
                                  "Deadline: ${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                            ],
                          )
                        : null,
                    onTap: () {
                      // nanti dipakai buat edit / toggle selesai
                    },
                  ),
                );
              },
            ),
    );
  }
}
