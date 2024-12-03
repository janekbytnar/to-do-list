import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:soft_for/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:soft_for/blocs/task_bloc/task_bloc.dart';
import 'package:soft_for/components/my_button.dart';
import 'package:soft_for/components/my_dialog.dart';
import 'package:soft_for/lib/completed_tasks/views/completed_tasks.dart';
import 'package:soft_for/lib/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:soft_for/lib/screens/home/blocs/task_management_bloc/task_management_bloc.dart';
import 'package:task_repository/task_repository.dart';
import 'package:user_repository/user_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<String>> tasks;
  late Future<MyUser?> userFuture;

  @override
  void initState() {
    super.initState();
    final userId = context.read<AuthenticationBloc>().state.user!.uid;
    context.read<TaskBloc>().add(LoadTasks(userId));
    userFuture = context.read<UserRepository>().getCurrentUserData();
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
      color: child.isCompleted! ? Colors.green : Colors.red,
      margin: const EdgeInsets.fromLTRB(20.0, 13.0, 20.0, 0),
      child: ListTile(
        title: Text(
          child.task,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Text(
          child.isCompleted!
              ? 'Completed at ${formatDateTime(child.lastUpdate)}'
              : 'Created at ${formatDateTime(child.lastUpdate)}',
        ),
        trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              context
                  .read<TaskManagementBloc>()
                  .add(RemoveTaskEvent(child.taskId));
              context.read<TaskBloc>().add(LoadTasks(child.userId));
            }),
        onTap: child.isCompleted!
            ? null
            : () {
                context
                    .read<TaskManagementBloc>()
                    .add(UpdateTaskEvent(child.taskId));
                context.read<TaskBloc>().add(LoadTasks(child.userId));
              },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.history),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CompletedTasksScreen(),
              ),
            );
          },
        ),
        title: FutureBuilder<MyUser?>(
          future: userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            } else if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              return Text('${snapshot.data!.firstName}\'s to do list');
            } else {
              return const Text('No user data');
            }
          },
        ),
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
    final taskBloc = context.read<TaskBloc>();

    showDialog(
      context: context,
      builder: (context) {
        return MyDialog(
          title: 'Task',
          onAdd: (name) {
            final newTask = Task(
              taskId: UniqueKey().toString(),
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
            taskBloc.add(LoadTasks(userId));
          },
        );
      },
    );
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }
}
