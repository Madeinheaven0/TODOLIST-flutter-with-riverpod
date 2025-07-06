class Todo {
  final int? id;
  final String title;
  final String description;
  final DateTime creationDate;
  final bool isCompleted;

  const Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.creationDate,
    this.isCompleted = false
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "creationDate": creationDate.toIso8601String(),
      "isCompleted": isCompleted? 1:0
    };
  }

  factory Todo.fromMap(Map<String, dynamic> todo) {
    return Todo(
                id: todo["id"] as int?,
                title: todo["title"] as String,
                description: todo["description"] as String,
                creationDate: DateTime.parse(todo["creationDate"] as String),
                isCompleted: todo["isCompleted"] == 1? true:false
    );
  }

  Todo copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? creationDate,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      creationDate: creationDate ?? this.creationDate,
      isCompleted: isCompleted?? this.isCompleted
    );
  }
}