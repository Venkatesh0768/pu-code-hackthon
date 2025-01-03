import 'package:http/http.dart' as http;
import 'dart:convert';

class SignLanguageService {
  static const String baseUrl = 'YOUR_API_ENDPOINT';

  Future<String> translateTextToSign(String text) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/translate'),
        body: json.encode({'text': text}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['signVideoUrl'];
      } else {
        throw Exception('Failed to translate text');
      }
    } catch (e) {
      throw Exception('Translation error: $e');
    }
  }
}