part of 'text_completion_cubit.dart';

abstract class TextCompletionState extends Equatable {
  const TextCompletionState();

  @override
  List<Object> get props => [];
}

class TextCompletionInitial extends TextCompletionState {}

class TextCompletionLoading extends TextCompletionState {}

class TextCompletionLoaded extends TextCompletionState {
  final GeminiResponseModel geminiResponse;

  const TextCompletionLoaded(this.geminiResponse);

  @override
  List<Object> get props => [geminiResponse];
}

class TextCompletionError extends TextCompletionState {
  final String message;

  const TextCompletionError({required this.message});

  @override
  List<Object> get props => [message];
}