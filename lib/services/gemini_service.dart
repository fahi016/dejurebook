import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiStreamService {
  final String _baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models";
  final String _model = "gemini-2.5-flash"; // ✅ supported streaming model

  /// Stream Gemini's response chunk by chunk
  Stream<String> streamResponse(String prompt) async* {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception("Gemini API key not found in .env file");
    }

    // Use SSE for true token streaming
    final uri = Uri.parse(
        "$_baseUrl/$_model:streamGenerateContent?alt=sse&key=$apiKey");
    final requestBody = jsonEncode({
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    });

    final request = http.Request("POST", uri)
      ..headers["Content-Type"] = "application/json"
      ..headers["Accept"] = "text/event-stream"
      ..headers["Cache-Control"] = "no-cache"
      ..body = requestBody;

    final client = http.Client();
    final streamedResponse = await client.send(request);

    if (streamedResponse.statusCode != 200) {
      final errorBody = await streamedResponse.stream.bytesToString();
      client.close();
      throw Exception(
          'Gemini streaming failed (${streamedResponse.statusCode}): $errorBody');
    }

    final stream = streamedResponse.stream.transform(utf8.decoder);

    await for (final chunk in stream) {
      // The stream sends multiple "data:" JSON chunks separated by newlines.
      for (final line in const LineSplitter().convert(chunk)) {
        if (line.startsWith('data: ')) {
          final jsonStr = line.substring(6).trim();
          if (jsonStr == '[DONE]') continue;

          try {
            final data = jsonDecode(jsonStr);
            // Some events may include multiple parts; concatenate available text parts
            String accumulatedText = '';
            final parts = data['candidates']?[0]?['content']?['parts'];
            if (parts is List) {
              for (final part in parts) {
                final t = part is Map ? part['text'] : null;
                if (t is String && t.isNotEmpty) {
                  accumulatedText += t;
                }
              }
            }

            if (accumulatedText.isNotEmpty) {
              yield accumulatedText; // Yield delta chunk
            }
          } catch (e) {
            // skip malformed chunks
          }
        }
      }
    }

    client.close();
  }
}
