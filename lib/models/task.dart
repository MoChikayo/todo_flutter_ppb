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
    // Convert Task -> Map (untuk disimpan di Hive)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'dueDate': dueDate?.toIso8601String(),
    };
  }
  // Convert Map -> Task (untuk dibaca dari Hive)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'] ?? '',
      description: map['description'],
      isCompleted: map['isCompleted'] ?? false,
      dueDate:
          map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
    );
  }
}
