import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/gemini_api_service.dart';
import 'text_completion_state.dart';
import 'text_completion_event.dart';

class TextCompletionBloc extends Bloc<TextCompletionEvent, TextCompletionState> {
  final GeminiApiService _apiService;

  TextCompletionBloc(this._apiService) : super(TextCompletionInitial()) {
    on<GenerateTextEvent>((event, emit) async {
      try {
        emit(TextCompletionLoading());
        final response = await _apiService.generateContent(event.prompt);
        // Handle response and emit success state
        emit(TextCompletionSuccess(response));
      } catch (e) {
        emit(TextCompletionError(e.toString()));
      }
    });
  }
}
