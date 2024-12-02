import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_repository/task_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'task_management_event.dart';
part 'task_management_state.dart';

class TaskManagementBloc
    extends Bloc<TaskManagementEvent, TaskManagementState> {
  final TaskRepository taskRepository;
  final UserRepository userRepository;

  TaskManagementBloc(
      {required this.taskRepository, required this.userRepository})
      : super(TaskManagementInitial()) {
    on<AddTaskEvent>(_onAddTask);
    on<RemoveTaskEvent>(_onRemoveTask);
    on<UpdateTaskEvent>(_onUpdateTask);
  }

  Future<void> _onAddTask(
      AddTaskEvent event, Emitter<TaskManagementState> emit) async {
    emit(TaskManagementLoading());
    try {
      await taskRepository.addTask(event.task);
      emit(TaskManagementSuccess());
    } catch (e) {
      emit(TaskManagementFailure(e.toString()));
    }
  }

  Future<void> _onRemoveTask(
      RemoveTaskEvent event, Emitter<TaskManagementState> emit) async {
    emit(TaskManagementLoading());
    try {
      await taskRepository.removeTask(event.taskId);
      emit(TaskManagementSuccess());
    } catch (e) {
      emit(TaskManagementFailure(e.toString()));
    }
  }

  Future<void> _onUpdateTask(
      UpdateTaskEvent event, Emitter<TaskManagementState> emit) async {
    emit(TaskManagementLoading());
    try {
      await taskRepository.isCompleted(event.taskId);
      emit(TaskManagementSuccess());
    } catch (e) {
      emit(TaskManagementFailure(e.toString()));
    }
  }
}
