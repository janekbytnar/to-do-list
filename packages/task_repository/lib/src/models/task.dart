import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class Task extends Equatable {
  final String taskId;
  final String userId;
  final String task;
  final bool isCompleted;

  const Task({
    required this.taskId,
    required this.userId,
    required this.task,
    required this.isCompleted,
  });

  static const empty = Task(
    taskId: '',
    userId: '',
    task: '',
    isCompleted: false,
  );

  Task copyWith({
    String? taskId,
    String? userId,
    String? task,
    bool? isCompleted,
  }) {
    return Task(
      taskId: taskId ?? this.taskId,
      userId: userId ?? this.userId,
      task: task ?? this.task,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  TaskEntity toEntity() {
    return TaskEntity(
      taskId: taskId,
      userId: userId,
      task: task,
      isCompleted: isCompleted,
    );
  }

  static Task fromEntity(TaskEntity entity) {
    return Task(
      taskId: entity.taskId,
      userId: entity.userId,
      task: entity.task,
      isCompleted: entity.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        taskId,
        userId,
        task,
        isCompleted,
      ];
}
