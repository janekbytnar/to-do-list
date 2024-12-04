import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:soft_for/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:soft_for/blocs/task_bloc/task_bloc.dart';
import 'package:soft_for/components/my_button.dart';
import 'package:soft_for/lib/screens/home/blocs/task_management_bloc/task_management_bloc.dart';
import 'package:soft_for/lib/screens/quiz_app/views/quiz_app.dart';
import 'package:user_repository/user_repository.dart';

class CompletedTasksScreen extends StatefulWidget {
  const CompletedTasksScreen({Key? key}) : super(key: key);

  @override
  _CompletedTasksScreenState createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  late Future<List<String>> tasks;
  late Future<MyUser?> userFuture;

  @override
  void initState() {
    super.initState();
    final userId = context.read<AuthenticationBloc>().state.user!.uid;
    context.read<TaskBloc>().add(LoadCompletedTasks(userId));
    userFuture = context.read<UserRepository>().getCurrentUserData();
  }

  Widget _playGameButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: MyTextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const QuizPage(),
              ),
            );
          },
          text: 'Play Game'),
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
      color: Colors.green,
      margin: const EdgeInsets.fromLTRB(20.0, 13.0, 20.0, 0),
      child: ListTile(
        title: Text(
          child.task,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Text('Completed at ${formatDateTime(child.lastUpdate)}'),
        trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              context
                  .read<TaskManagementBloc>()
                  .add(RemoveTaskEvent(child.taskId));
              context.read<TaskBloc>().add(LoadTasks(child.userId));
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Completed tasks'),
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
                  return const Center(child: Text('No completed tasks.'));
                } else if (state.status == TaskStatus.failure) {
                  return Center(child: Text('Error: ${state.error}'));
                } else {
                  return Container();
                }
              },
            ),
          ),
          _playGameButton(context),
        ],
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }
}
