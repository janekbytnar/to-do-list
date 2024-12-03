import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_for/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:soft_for/blocs/task_bloc/task_bloc.dart';
import 'package:soft_for/components/my_button.dart';
import 'package:soft_for/components/my_dialog.dart';
import 'package:soft_for/lib/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:soft_for/lib/screens/home/views/blocs/task_management_bloc/task_management_bloc.dart';
import 'package:task_repository/task_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<String>> tasks;

  @override
  void initState() {
    super.initState();
    final userId = context.read<AuthenticationBloc>().state.user!.uid;
    context.read<TaskBloc>().add(LoadTasks(userId));
  }

  Widget _logoutButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<SignInBloc>().add(
              const SignOutRequired(),
            );
      },
      icon: const Icon(
        Icons.logout,
        color: Colors.red,
      ),
    );
  }

  Widget _addButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: MyTextButton(
          onPressed: () {
            _showAddTaskDialog(context);
          },
          text: 'Add Task'),
    );
  }

  Widget _listTiles(state) {
    return ListView.builder(
      itemCount: state.tasks.length,
      itemBuilder: (context, index) {
        final child = state.tasks[index];
        return _tile(child);
      },
    );
  }

  Widget _tile(child) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      color: Colors.blue,
      margin: const EdgeInsets.fromLTRB(20.0, 13.0, 20.0, 0),
      child: ListTile(
        title: Text(
          child.task,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        onTap: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [_logoutButton(context)],
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state.status == TaskStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status == TaskStatus.hasTasks) {
                  return _listTiles(state);
                } else if (state.status == TaskStatus.noTasks) {
                  return const Center(child: Text('No tasks available.'));
                } else if (state.status == TaskStatus.failure) {
                  return Center(child: Text('Error: ${state.error}'));
                } else {
                  return Container();
                }
              },
            ),
          ),
          _addButton(context),
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) async {
    final userId = context.read<AuthenticationBloc>().state.user!.uid;
    final taskManagementBloc = context.read<TaskManagementBloc>();

    showDialog(
      context: context,
      builder: (context) {
        return MyDialog(
            title: 'Task',
            onAdd: (name) {
              final newTask = Task(
                taskId: '',
                userId: userId,
                task: name,
                isCompleted: false,
                createdAt: DateTime.now(),
                lastUpdate: DateTime.now(),
              );
              taskManagementBloc.add(
                AddTaskEvent(
                  newTask,
                  userId,
                ),
              );
            });
      },
    );
  }
}
