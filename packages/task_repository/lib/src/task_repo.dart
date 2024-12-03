import 'models/models.dart';

abstract class TaskRepository {
  Future<void> addTask(Task taskDescription);
  Future<void> removeTask(String taskId);
  Future<void> isCompleted(String taskId);
  Future<List<Task>> getTasksByUserId(String userId);
  Future<List<Task>> getCompletedTasksByUserId(String userId);
}
