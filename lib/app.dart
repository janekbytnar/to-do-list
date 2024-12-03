import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_for/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:soft_for/blocs/task_bloc/task_bloc.dart';
import 'package:task_repository/task_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'app_view.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  final TaskRepository taskRepository;
  const MyApp(this.userRepository, this.taskRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (_) => userRepository,
        ),
        RepositoryProvider<TaskRepository>(
          create: (_) => taskRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => TaskBloc(
              taskRepository: context.read<TaskRepository>(),
            ),
          ),
        ],
        child: const MyAppView(),
      ),
    );
  }
}
