import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_repository/task_repository.dart';

class FirebaseTaskRepo implements TaskRepository {
  final taskCollection = FirebaseFirestore.instance.collection('task');

  FirebaseTaskRepo();

  @override
  Future<void> addTask(Task task) async {
    try {
      await taskCollection.add(task.toEntity().toDocument());
    } catch (e) {
      log('Error adding task: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> removeTask(String taskId) async {
    try {
      await taskCollection.doc(taskId).delete();
    } catch (e) {
      log('Error removing session: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> isCompleted(String taskId) async {
    try {
      await taskCollection.doc(taskId).update({
        'isCompleted': true,
      });
    } catch (e) {
      log('Error updating task: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<Task>> getTasksByUserId(String userId) async {
    try {
      final querySnapshot =
          await taskCollection.where('userId', isEqualTo: userId).get();

      final tasks = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        // Add the document ID to the data map
        data['taskId'] = doc.id;

        final taskEntity = TaskEntity.fromDocument(data);
        return Task.fromEntity(taskEntity);
      }).toList();

      return tasks;
    } catch (e) {
      throw Exception('Failed to load tasks: $e');
    }
  }
}
