import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/src/todo_bloc.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _todoBloc = TodoBloc();
  @override
  Widget build(BuildContext context) => BlocConsumer<TodoBloc, TodoState>(
    bloc: _todoBloc..add(TodoEvent.fetch(name: 'TodoEvent.fetch()')),

    listener: _todoBlocListener,
    buildWhen: (previous, current) => !current.isProcessing,
    builder: (context, state) {
      return Scaffold(
        body: Center(
          child: state.map(
            idle: (_) => SizedBox.shrink(),
            processing: (_) => CircularProgressIndicator(),
            successful:
                (success) => ListView.builder(
                  itemCount: success.data!.todos.length,
                  itemBuilder: (context, index) {
                    final todo = success.data!.todos[index];
                    return ListTile(
                      title: Text(todo.todo),
                      subtitle: Text('${todo.id}'),
                    );
                  },
                ),
            error: (err) => Text(err.message),
          ),
        ),
      );
    },
  );

  void _todoBlocListener(BuildContext context, TodoState state) {
    state.mapOrNull(
      successful:
          (state) => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Todo fetched'))),
    );
  }
}
