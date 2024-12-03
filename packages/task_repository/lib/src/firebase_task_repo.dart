import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_repository/task_repository.dart';

class FirebaseTaskRepo implements TaskRepository {
  final taskCollection = FirebaseFirestore.instance.collection('task');

  FirebaseTaskRepo();

  @override
  Future<void> addTask(Task task) async {
    try {
      await taskCollection.doc(task.taskId).set(task.toEntity().toDocument());
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
        'lastUpdate': DateTime.now(),
      });
    } catch (e) {
      log('Error updating task: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<Task>> getTasksByUserId(String userId) async {
    try {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      final incompleteQuerySnapshot = await taskCollection
          .where('userId', isEqualTo: userId)
          .where('isCompleted', isEqualTo: false)
          .get();

      final completedQuerySnapshot = await taskCollection
          .where('userId', isEqualTo: userId)
          .where('isCompleted', isEqualTo: true)
          .where('lastUpdate', isGreaterThan: yesterday)
          .get();

      final tasks = [
        ...incompleteQuerySnapshot.docs.map((doc) {
          final data = doc.data();
          data['taskId'] = doc.id;
          final taskEntity = TaskEntity.fromDocument(data);
          return Task.fromEntity(taskEntity);
        }),
        ...completedQuerySnapshot.docs.map((doc) {
          final data = doc.data();
          data['taskId'] = doc.id;
          final taskEntity = TaskEntity.fromDocument(data);
          return Task.fromEntity(taskEntity);
        }),
      ];

      return tasks;
    } catch (e) {
      throw Exception('Failed to load tasks: $e');
    }
  }
}
