part of 'task_management_bloc.dart';

abstract class TaskManagementEvent extends Equatable {
  const TaskManagementEvent();

  @override
  List<Object?> get props => [];
}

class AddTaskEvent extends TaskManagementEvent {
  final Task task;
  final String userId;

  const AddTaskEvent(
    this.task,
    this.userId,
  );

  @override
  List<Object?> get props => [task];
}

class RemoveTaskEvent extends TaskManagementEvent {
  final String taskId;

  const RemoveTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class UpdateTaskEvent extends TaskManagementEvent {
  final Task task;

  const UpdateTaskEvent(this.task);

  @override
  List<Object> get props => [task];
}
