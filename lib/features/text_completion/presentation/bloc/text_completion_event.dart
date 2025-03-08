abstract class TextCompletionEvent {}

class GenerateTextEvent extends TextCompletionEvent {
  final String prompt;
  GenerateTextEvent(this.prompt);
} 