part of 'task_management_bloc.dart';

abstract class TaskManagementState extends Equatable {
  const TaskManagementState();

  @override
  List<Object?> get props => [];
}

class TaskManagementInitial extends TaskManagementState {}

class TaskManagementLoading extends TaskManagementState {}

class TaskManagementSuccess extends TaskManagementState {}

class TaskManagementFailure extends TaskManagementState {
  final String error;

  const TaskManagementFailure(this.error);
  @override
  List<Object?> get props => [error];
}
