import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_repository/task_repository.dart';

class FirebaseTaskRepo implements TaskRepository {
  final taskCollection = FirebaseFirestore.instance.collection('tasks');

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
}
