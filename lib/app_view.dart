import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_for/blocs/task_bloc/task_bloc.dart';
import 'package:soft_for/lib/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:soft_for/lib/screens/auth/views/welcome_screen.dart';
import 'package:soft_for/lib/screens/home/views/blocs/task_management_bloc/task_management_bloc.dart';
import 'package:soft_for/lib/screens/home/views/home.dart';
import 'package:task_repository/task_repository.dart';
import 'package:user_repository/user_repository.dart';

import 'blocs/authentication_bloc/authentication_bloc.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Software for enterprise',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          surface: Colors.grey.shade200,
          onSurface: Colors.black,
        ),
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, authState) {
          //user is authenticated
          if (authState.status == AuthenticationStatus.authenticated) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => SignInBloc(
                    userRepository:
                        context.read<AuthenticationBloc>().userRepository,
                  ),
                ),
                BlocProvider(
                  create: (context) => TaskBloc(
                    taskRepository: context.read<TaskRepository>(),
                  ),
                ),
                BlocProvider(
                  create: (context) => TaskManagementBloc(
                    taskRepository: context.read<TaskRepository>(),
                    userRepository: context.read<UserRepository>(),
                  ),
                ),
              ],
              child: const HomeScreen(),
            );
          } else {
            // User is not authenticated
            return const WelcomeScreen();
          }
        },
      ),
    );
  }
}
