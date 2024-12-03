import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class Task extends Equatable {
  final String taskId;
  final String userId;
  final String task;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime lastUpdate;

  const Task({
    required this.taskId,
    required this.userId,
    required this.task,
    required this.isCompleted,
    required this.createdAt,
    required this.lastUpdate,
  });

  static final empty = Task(
    taskId: '',
    userId: '',
    task: '',
    isCompleted: false,
    createdAt: DateTime(1970, 1, 1),
    lastUpdate: DateTime(1970, 1, 1),
  );

  Task copyWith({
    String? taskId,
    String? userId,
    String? task,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? lastUpdate,
  }) {
    return Task(
      taskId: taskId ?? this.taskId,
      userId: userId ?? this.userId,
      task: task ?? this.task,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  TaskEntity toEntity() {
    return TaskEntity(
      taskId: taskId,
      userId: userId,
      task: task,
      isCompleted: isCompleted,
      createdAt: createdAt,
      lastUpdate: lastUpdate,
    );
  }

  static Task fromEntity(TaskEntity entity) {
    return Task(
      taskId: entity.taskId,
      userId: entity.userId,
      task: entity.task,
      isCompleted: entity.isCompleted,
      createdAt: entity.createdAt,
      lastUpdate: entity.lastUpdate,
    );
  }

  @override
  List<Object?> get props => [
        taskId,
        userId,
        task,
        isCompleted,
        createdAt,
        lastUpdate,
      ];
}
