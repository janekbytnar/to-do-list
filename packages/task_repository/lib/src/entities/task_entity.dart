import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:task_repository/task_repository.dart';

class TaskEntity extends Equatable {
  final String taskId;
  final String userId;
  final String task;
  final bool isCompleted;

  final DateTime createdAt;
  final DateTime lastUpdate;

  const TaskEntity({
    required this.taskId,
    required this.userId,
    required this.task,
    required this.isCompleted,
    required this.createdAt,
    required this.lastUpdate,
  });

  Map<String, Object?> toDocument() {
    return {
      'taskId': taskId,
      'userId': userId,
      'task': task,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastUpdate': Timestamp.fromDate(lastUpdate),
    };
  }

  static TaskEntity fromDocument(Map<String, dynamic> doc) {
    return TaskEntity(
      taskId: doc['taskId'] ?? '',
      userId: doc['userId'] ?? '',
      task: doc['task'] ?? '',
      isCompleted: doc['isCompleted'] ?? false,
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
      lastUpdate: (doc['lastUpdate'] as Timestamp).toDate(),
    );
  }

  Task toModel() {
    return Task(
      taskId: taskId,
      userId: userId,
      task: task,
      isCompleted: isCompleted,
      createdAt: createdAt,
      lastUpdate: lastUpdate,
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
