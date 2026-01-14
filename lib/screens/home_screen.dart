import 'package:flutter/material.dart';
import '../models/task.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  
  Future<void> _navigateToEditTask(Task task, int index) async {
    final updatedTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(task: task),
      ),
    );

    if (updatedTask != null) {
      setState(() {
        tasks[index] = updatedTask;
      });
    }
  }

  void _toggleTaskCompleted(int index, bool? value) {
    setState(() {
      tasks[index].isCompleted = value ?? false;
    });
  }

  void _deleteTask(int index) {
    final deletedTask = tasks[index];

    setState(() {
      tasks.removeAt(index);
    });

    // Snackbar undo (bonus UX)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${deletedTask.title}" dihapus'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              tasks.insert(index, deletedTask);
            });
          },
        ),
      ),
    );
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

                return Dismissible(
                  key: ValueKey("${task.title}-$index"),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    _deleteTask(index);
                  },
                  child: Card(
                    child: ListTile(
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (value) =>
                            _toggleTaskCompleted(index, value),
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
                    onTap: () => _navigateToEditTask(task, index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
