import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // dummy list sementara (nanti diganti storage)
  List<String> tasks = [
    "Belajar Flutter",
    "Kerjakan Tugas PPB",
    "Istirahat"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My To-Do List"),
        centerTitle: true,
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // nanti diarahkan ke Add Task
        },
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
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.check_box_outline_blank),
                    title: Text(tasks[index]),
                  ),
                );
              },
            ),
    );
  }
}
