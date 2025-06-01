sealed class Example {
  bool get isProcessing => this is ExampleProcessing;

  bool get isError => this is ExampleError;

  bool get hasData => this is ExampleSuccessful;
}

final class ExampleInitial extends Example {}

final class ExampleProcessing extends Example {}

final class ExampleSuccessful extends Example {
  ExampleSuccessful({required this.data});

  final Object data;
}

final class ExampleError extends Example {}
