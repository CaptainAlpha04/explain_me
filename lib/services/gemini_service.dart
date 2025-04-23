import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../utils/secrets.dart';
import '../models/theme_model.dart';

class SlideContent {
  final String text;
  final String? imageBase64;

  SlideContent({required this.text, this.imageBase64});
}

class GeminiService {
  final String apiKey = AppSecrets.geminiApiKey;
  final String baseUrl = "https://generativelanguage.googleapis.com/v1";

  // Generate content with Gemini that includes both text and images
  Future<List<SlideContent>> generateExplanation(
      String query, ArtTheme theme, Character character) async {
    try {
      final endpoint =
          '$baseUrl/models/gemini-1.5-flash:generateContent?key=$apiKey';

      final additionalInstructions = '''
Use a fun story about ${character.name} as a metaphor.
Keep sentences short but conversational, casual, and engaging.
Generate a cute, minimal illustration for each sentence in a ${theme.name} style with black ink on white background.
No commentary, just begin your explanation.
Keep going until you're done.
Each illustration should be followed by its related text explanation.''';

      final fullQuery = '$query\n$additionalInstructions';

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': fullQuery}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 2048,
            'responseSchema': {
              'type': 'PROTOTYPE',
              'properties': {
                'explanation': {
                  'type': 'STRING',
                  'description': 'The explanation of the concept'
                },
                'images': {
                  'type': 'ARRAY',
                  'items': {
                    'type': 'IMAGE',
                    'description': 'An illustration for the explanation'
                  }
                }
              }
            }
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<SlideContent> slides = [];

        // Try to extract images and text from the response
        try {
          final content = data['candidates'][0]['content'];
          final parts = content['parts'] as List;

          String currentText = '';
          String? currentImage;

          for (var part in parts) {
            if (part.containsKey('text')) {
              currentText += part['text'];
            } else if (part.containsKey('inlineData')) {
              currentImage = part['inlineData']['data'];

              if (currentText.isNotEmpty) {
                slides.add(SlideContent(
                  text: currentText,
                  imageBase64: currentImage,
                ));
                currentText = '';
                currentImage = null;
              }
            }
          }

          // Add any remaining text
          if (currentText.isNotEmpty) {
            slides.add(SlideContent(
              text: currentText,
              imageBase64: currentImage,
            ));
          }
        } catch (e) {
          // If structured parsing fails, try to get at least the text
          try {
            final text = data['candidates'][0]['content']['parts'][0]['text'];
            slides.add(SlideContent(text: text, imageBase64: null));
          } catch (e) {
            debugPrint('Error parsing response: $e');
            return _generateFallbackContent(query, theme, character);
          }
        }

        if (slides.isEmpty) {
          return _generateFallbackContent(query, theme, character);
        }

        return slides;
      } else {
        debugPrint('API Error: ${response.statusCode} ${response.body}');
        return _generateFallbackContent(query, theme, character);
      }
    } catch (e) {
      debugPrint('Error generating content: $e');
      return _generateFallbackContent(query, theme, character);
    }
  }

  // Fallback content generator for testing or when API fails
  Future<List<SlideContent>> _generateFallbackContent(
      String query, ArtTheme theme, Character character) async {
    // Create sample slides for testing
    return [
      SlideContent(
        text:
            'Imagine a world where tiny ${character.name}s explain "$query" through ${theme.name} style illustrations! Let\'s begin our journey.',
        imageBase64: null,
      ),
      SlideContent(
        text:
            'This is a simple explanation of $query. Think of it as a story where each concept builds on the previous one.',
        imageBase64: null,
      ),
      SlideContent(
        text:
            'The end! I hope you enjoyed learning about $query with ${character.name} in ${theme.name} style.',
        imageBase64: null,
      ),
    ];
  }
}
