class Task {
  String title;
  String? description;
  bool isCompleted;
  DateTime? dueDate;

  Task({
    required this.title,
    this.description,
    this.isCompleted = false,
    this.dueDate,
  });
}
