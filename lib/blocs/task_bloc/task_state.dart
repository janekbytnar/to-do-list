part of 'task_bloc.dart';

enum TaskStatus { hasTasks, noTasks, loading, failure }

class TaskState extends Equatable {
  final TaskStatus status;
  final List<Task> tasks;
  final String? error;

  const TaskState._({
    required this.status,
    this.tasks = const [],
    this.error,
  });

  const TaskState.loading() : this._(status: TaskStatus.loading);

  const TaskState.hasTasks(List<Task> tasks)
      : this._(status: TaskStatus.hasTasks, tasks: tasks);

  const TaskState.noTasks()
      : this._(status: TaskStatus.noTasks, tasks: const []);

  const TaskState.failure(String error)
      : this._(status: TaskStatus.failure, error: error);

  @override
  List<Object?> get props => [status, tasks, error];
}
