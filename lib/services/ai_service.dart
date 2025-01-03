import 'package:http/http.dart' as http;
import 'dart:convert';
class AiAssistantService {
  Future<String> getAiResponse(String query) async {
    try {
      final response = await http.post(
        Uri.parse('YOUR_AI_ENDPOINT'),
        body: json.encode({'query': query}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['response'];
      } else {
        throw Exception('Failed to get AI response');
      }
    } catch (e) {
      throw Exception('AI service error: $e');
    }
  }
}