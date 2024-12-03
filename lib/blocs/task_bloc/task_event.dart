part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {
  final String userId;

  const LoadTasks(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadCompletedTasks extends TaskEvent {
  final String userId;

  const LoadCompletedTasks(this.userId);

  @override
  List<Object?> get props => [userId];
}
