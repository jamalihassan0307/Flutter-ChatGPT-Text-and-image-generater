abstract class TextCompletionState {}

class TextCompletionInitial extends TextCompletionState {}
class TextCompletionLoading extends TextCompletionState {}
class TextCompletionSuccess extends TextCompletionState {
  final Map<String, dynamic> response;
  TextCompletionSuccess(this.response);
}
class TextCompletionError extends TextCompletionState {
  final String message;
  TextCompletionError(this.message);
} 