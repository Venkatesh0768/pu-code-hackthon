import 'package:speech_to_text/speech_to_text.dart';

class SpeechRecognitionService {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;

  Future<bool> initialize() async {
    if (!_isInitialized) {
      _isInitialized = await _speechToText.initialize();
    }
    return _isInitialized;
  }

  Future<void> startListening(Function(String) onResult) async {
    if (!_isInitialized) await initialize();
    
    await _speechToText.listen(
      onResult: (result) => onResult(result.recognizedWords),
      listenFor: Duration(seconds: 30),
      localeId: 'en_IN',
    );
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }
}
