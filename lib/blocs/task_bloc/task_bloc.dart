import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_repository/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  TaskBloc({required this.taskRepository}) : super(const TaskState.loading()) {
    on<LoadTasks>(_onLoadTasks);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(const TaskState.loading());

    try {
      final tasks = await taskRepository.getTasksByUserId(event.userId);

      if (tasks.isNotEmpty) {
        emit(TaskState.hasTasks(tasks));
      } else {
        emit(const TaskState.noTasks());
      }
    } catch (error) {
      emit(TaskState.failure(error.toString()));
    }
  }
}
