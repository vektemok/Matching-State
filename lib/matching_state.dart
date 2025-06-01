library;

import 'package:flutter/foundation.dart';

/// {@template MatchingState}
/// MatchingState.
/// {@endtemplate}
sealed class MatchingState<T> extends _$MatchingStateBase<T> {
  /// Idling state
  /// {@macro MatchingState}
  const factory MatchingState.idle({T? data, String message}) =
      MatchingState$Idle;

  /// Processing
  /// {@macro MatchingState}
  const factory MatchingState.processing({T? data, String message}) =
      MatchingState$Processing;

  /// Successful
  /// {@macro MatchingState}
  const factory MatchingState.successful({required T data, String message}) =
      MatchingState$Successful;

  /// An error has occurred
  /// {@macro MatchingState}
  const factory MatchingState.error({
    T? data,
    String message,
    StackTrace stackTrace,
  }) = MatchingState$Error;

  /// {@macro MatchingState}
  const MatchingState({super.data, required super.message});
}

final class MatchingState$Idle<T> extends MatchingState<T> {
  const MatchingState$Idle({super.data, super.message = 'Idling'});
}

/// Processing

final class MatchingState$Processing<T> extends MatchingState<T> {
  const MatchingState$Processing({super.data, super.message = 'Processing'});
}

/// Successful

final class MatchingState$Successful<T> extends MatchingState<T> {
  const MatchingState$Successful({
    required super.data,
    super.message = 'Successful',
  });
}

/// Error

final class MatchingState$Error<T> extends MatchingState<T> {
  const MatchingState$Error({
    super.data,
    super.message = 'An error has occurred.',
    StackTrace? stackTrace,
  });
}

/// Pattern matching for [MatchingState].
typedef MatchingStateMatch<R, S extends MatchingState> = R Function(S state);

@immutable
abstract base class _$MatchingStateBase<T extends Object?> {
  const _$MatchingStateBase({this.data, required this.message});

  /// Data entity payload.
  @nonVirtual
  final T? data;

  /// Message or state description.
  @nonVirtual
  final String message;

  /// Has data?
  bool get hasData => data != null;

  /// If an error has occurred?
  bool get hasError => maybeMap<bool>(orElse: () => false, error: (_) => true);

  /// Is in progress state?
  bool get isProcessing =>
      maybeMap<bool>(orElse: () => false, processing: (_) => true);

  /// Is in idle state?
  bool get isIdling => !isProcessing;

  /// Pattern matching for [MatchingState].
  R map<R>({
    required MatchingStateMatch<R, MatchingState$Idle<T?>> idle,
    required MatchingStateMatch<R, MatchingState$Processing<T?>> processing,
    required MatchingStateMatch<R, MatchingState$Successful<T>> successful,
    required MatchingStateMatch<R, MatchingState$Error<T?>> error,
  }) => switch (this) {
    MatchingState$Idle<T> s => idle(s),
    MatchingState$Processing<T> s => processing(s),
    MatchingState$Successful<T> s => successful(s),
    MatchingState$Error<T> s => error(s),
    _ => throw AssertionError(),
  };

  /// Pattern matching for [MatchingState].
  R maybeMap<R>({
    MatchingStateMatch<R, MatchingState$Idle<T?>>? idle,
    MatchingStateMatch<R, MatchingState$Processing<T?>>? processing,
    MatchingStateMatch<R, MatchingState$Successful<T>>? successful,
    MatchingStateMatch<R, MatchingState$Error<T?>>? error,
    required R Function() orElse,
  }) => map<R>(
    idle: idle ?? (_) => orElse(),
    processing: processing ?? (_) => orElse(),
    successful: successful ?? (_) => orElse(),
    error: error ?? (_) => orElse(),
  );

  /// Pattern matching for [MatchingState].
  R? mapOrNull<R>({
    MatchingStateMatch<R, MatchingState$Idle<T?>>? idle,
    MatchingStateMatch<R, MatchingState$Processing<T?>>? processing,
    MatchingStateMatch<R, MatchingState$Successful<T>>? successful,
    MatchingStateMatch<R, MatchingState$Error<T?>>? error,
  }) => map<R?>(
    idle: idle ?? (_) => null,
    processing: processing ?? (_) => null,
    successful: successful ?? (_) => null,
    error: error ?? (_) => null,
  );

  @override
  int get hashCode => data.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other);
}
