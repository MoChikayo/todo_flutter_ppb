import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/task.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasksFromLocal();
  }

void _loadTasksFromLocal() {
  final box = Hive.box('tasksBox');
  final storedTasks = box.get('tasks');

  if (storedTasks == null) {
    // belum ada data tersimpan
    tasks = [];
  } else if (storedTasks is List) {
    tasks = storedTasks
        .map((item) => Task.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  } else {
    tasks = [];
  }

  setState(() {});
}

Future<void> _saveTasksToLocal() async {
  final box = Hive.box('tasksBox');
  final listMap = tasks.map((task) => task.toMap()).toList();
  await box.put('tasks', listMap);
}

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
      await _saveTasksToLocal();
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
      await _saveTasksToLocal();
    }
  }

  Future<void> _toggleTaskCompleted(int index, bool? value) async {
    setState(() {
      tasks[index].isCompleted = value ?? false;
    });
    await _saveTasksToLocal();
  }

  Future<void> _deleteTask(int index) async {
    final deletedTask = tasks[index];

    setState(() {
      tasks.removeAt(index);
    });
    await _saveTasksToLocal();

    // Snackbar undo (bonus UX)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${deletedTask.title}" dihapus'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () async {
            setState(() {
              tasks.insert(index, deletedTask);
            });
            await _saveTasksToLocal();
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
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          )
                        : null,
                    onTap: () => _navigateToEditTask(task, index),
                        trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                      ),
                    onPressed: () {
                    _deleteTask(index);
                  },
                ),
              ),
              ),
              );
            },
          ),
    );
  }
}
