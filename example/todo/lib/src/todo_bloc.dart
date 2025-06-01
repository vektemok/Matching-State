import 'dart:convert';

import 'package:matching_state/matching_state.dart';
import 'package:todo/src/todo.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef TodoState = MatchingState<Todo>;

class TodoBloc extends Bloc<TodoEvent, TodoState>
    implements EventSink<TodoEvent> {
  TodoBloc({final TodoState? initialState})
    : super(initialState ?? TodoState.idle(message: 'Initial idle state')) {
    on<TodoEvent>(
      (event, emit) =>
          event.map<Future<void>>(fetch: (event) => _fetch(event, emit)),
    );
  }

  Future<void> _fetch(_FetchTodoEvent event, Emitter<TodoState> emit) async {
    try {
      emit(TodoState.processing(data: state.data));
      final response = await http.get(Uri.parse('https://dummyjson.com/todos'));

      final todo = Todo.fromJson(jsonDecode(response.body));

      emit(TodoState.successful(data: todo));
    } on Object catch (error, stackTrace) {
      emit(TodoState.error(data: state.data));
      onError(error, stackTrace);
      rethrow;
    }
  }
}

/// Business Logic Component TodoEvent
@immutable
sealed class TodoEvent extends _$TodoEventBase {
  const TodoEvent();

  const factory TodoEvent.fetch({required String name}) = _FetchTodoEvent;
}

final class _FetchTodoEvent extends TodoEvent {
  const _FetchTodoEvent({required this.name}) : super();

  final String name;

  @override
  String toString() {
    final buffer =
        StringBuffer()
          ..write('TodoEvent.fetch(')
          ..write('name: $name, ')
          ..write(')');
    return buffer.toString();
  }
}

typedef TodoEventMatch<R, E extends TodoEvent> = R Function(E event);

abstract base class _$TodoEventBase {
  const _$TodoEventBase();

  R map<R>({required TodoEventMatch<R, _FetchTodoEvent> fetch}) =>
      switch (this) {
        final _FetchTodoEvent e => fetch(e),
        _ => throw AssertionError(),
      };

  R maybeMap<R>({
    required R Function() orElse,
    TodoEventMatch<R, _FetchTodoEvent>? fetch,
  }) => map<R>(fetch: fetch ?? (_) => orElse());

  R? mapOrNull<R>({TodoEventMatch<R, _FetchTodoEvent>? fetch}) =>
      map<R?>(fetch: fetch ?? (_) => null);
}
