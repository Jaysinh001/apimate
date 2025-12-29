part of 'variable_bloc.dart';

enum CollectionVariablesStatus { initial, loading, loaded, error }

class CollectionVariablesState extends Equatable {
  final CollectionVariablesStatus status;
  final String? message;

  // UI-friendly variable list (we’ll define model later)
  final List<dynamic> variables;

  const CollectionVariablesState({
    this.status = CollectionVariablesStatus.initial,
    this.message,
    this.variables = const [],
  });

  CollectionVariablesState copyWith({
    CollectionVariablesStatus? status,
    String? message,
    List<dynamic>? variables,
  }) {
    return CollectionVariablesState(
      status: status ?? this.status,
      message: message,
      variables: variables ?? this.variables,
    );
  }

  @override
  List<Object?> get props => [status, message, variables];
}
