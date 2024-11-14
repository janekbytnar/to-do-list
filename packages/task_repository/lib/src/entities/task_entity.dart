import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String taskId;
  final String userId;
  final String task;
  final bool isCompleted;

  const TaskEntity({
    required this.taskId,
    required this.userId,
    required this.task,
    required this.isCompleted,
  });

  Map<String, Object?> toDocument() {
    return {
      'taskId': taskId,
      'userId': userId,
      'task': task,
      'isCompleted': isCompleted,
    };
  }

  static TaskEntity fromDocument(Map<String, dynamic> doc) {
    return TaskEntity(
      taskId: doc['taskId'] ?? '',
      userId: doc['userId'] ?? '',
      task: doc['task'] ?? '',
      isCompleted: doc['isCompleted'] ?? '',
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
