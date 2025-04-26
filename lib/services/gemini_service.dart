import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../utils/secrets.dart';
import '../models/theme_model.dart';

class SlideContent {
  final String? imageBase64;
  // Text field remains for internal processing but won't be displayed separately
  final String text;

  SlideContent({required this.text, this.imageBase64});
}

class GeminiService {
  final String apiKey = AppSecrets.geminiApiKey;
  // Using only v1beta API for image generation
  final String baseUrlV1Beta =
      'https://generativelanguage.googleapis.com/v1beta';

  // Generate content with Gemini as images with embedded text
  Future<List<SlideContent>> generateExplanation(
      String query, ArtTheme theme, Character character) async {
    try {
      debugPrint('Starting explanation generation with Gemini API...');

      // Generate text explanation first
      final List<SlideContent> textSlides =
          await _generateTextExplanation(query, theme, character);

      // Convert text slides to image slides with text embedded
      final List<SlideContent> imageSlides =
          await _generateImagesWithEmbeddedText(textSlides, theme);

      return imageSlides;
    } catch (e) {
      debugPrint('Error in generateExplanation: $e');
      // Rethrow the exception to be caught by the UI
      rethrow;
    }
  }

  Future<List<SlideContent>> _generateTextExplanation(
      String query, ArtTheme theme, Character character) async {
    try {
      final endpoint =
          '$baseUrlV1Beta/models/gemini-2.0-flash-exp-image-generation:generateContent?key=$apiKey';

      final instructions = '''
      Generate a fun story about "${character.description}" as a metaphor on the topic of "$query".
      Break it down into at least 5-20 distinct concepts that can be illustrated.
      Explain each concept in a simple, engaging, and kid-friendly way.
      No commentary, just begin your explanation.
      ''';

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': instructions}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 2048,
          },
        }),
      );

      debugPrint('Text generation response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<SlideContent> slides = [];

        try {
          final content = data['candidates'][0]['content'];
          final parts = content['parts'] as List;

          if (parts.isNotEmpty && parts[0].containsKey('text')) {
            final text = parts[0]['text'] as String;

            // Split by paragraphs (two or more newlines)
            final paragraphs = text
                .split(RegExp(r'\n\s*\n'))
                .where((p) => p.trim().isNotEmpty)
                .toList();

            debugPrint(
                'Found ${paragraphs.length} paragraphs in text response');

            // Convert paragraphs to slides
            for (final paragraph in paragraphs) {
              if (paragraph.trim().isNotEmpty) {
                slides.add(
                    SlideContent(text: paragraph.trim(), imageBase64: null));
              }
            }
          } else {
            debugPrint('No text part found in the response content.');
            throw Exception('No text part found in the response content.');
          }
        } catch (e) {
          debugPrint(
              'Error parsing text response: $e\nResponse body: ${response.body}');
          throw Exception('Failed to parse text response: $e');
        }

        if (slides.isEmpty) {
          // Fallback if splitting failed but text exists
          try {
            final text = data['candidates'][0]['content']['parts'][0]['text'];
            if (text != null && text.trim().isNotEmpty) {
              slides.add(SlideContent(text: text.trim(), imageBase64: null));
              debugPrint(
                  'Created a single slide from the entire response as fallback.');
            } else {
              throw Exception(
                  'No content could be extracted from the API response');
            }
          } catch (e) {
            debugPrint('Error creating single slide fallback: $e');
            throw Exception(
                'No content could be extracted from the API response');
          }
        }

        return slides;
      } else {
        final errorBody = response.body;
        debugPrint('API Error: ${response.statusCode} $errorBody');
        // Try to parse the error message from the response body
        String errorMessage = 'API Error: ${response.statusCode}';
        try {
          final errorJson = jsonDecode(errorBody);
          if (errorJson['error'] != null &&
              errorJson['error']['message'] != null) {
            errorMessage = errorJson['error']['message'];
          }
        } catch (_) {
          // Ignore parsing errors, use the status code
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error generating text explanation: $e');
      // Rethrow the exception to be caught by the UI
      rethrow;
    }
  }

  Future<List<SlideContent>> _generateImagesWithEmbeddedText(
      List<SlideContent> textSlides, ArtTheme theme) async {
    final List<SlideContent> imageSlides = [];

    debugPrint(
        'Starting image generation with embedded text for ${textSlides.length} slides...');

    for (int i = 0; i < textSlides.length; i++) {
      final slide = textSlides[i];
      String? imageBase64;

      try {
        // Generate image with text embedded directly in the image
        imageBase64 = await _generateImageWithText(slide.text, theme);
        if (imageBase64 != null) {
          debugPrint('Successfully generated image for slide ${i + 1}');
        } else {
          debugPrint('Image generation returned null for slide ${i + 1}');
        }
      } catch (e) {
        debugPrint('Failed to generate image for slide ${i + 1}: $e');
        // Continue without image if generation fails, imageBase64 remains null
      }

      // Add slide with image (text is kept for reference, but won't be displayed separately)
      imageSlides.add(SlideContent(
        text: slide.text,
        imageBase64: imageBase64,
      ));
    }

    return imageSlides;
  }

  Future<String?> _generateImageWithText(String text, ArtTheme theme) async {
    try {
      final endpoint =
          '$baseUrlV1Beta/models/gemini-2.0-flash-exp-image-generation:generateContent?key=$apiKey';

      // Clear instructions to generate image with embedded text
      final prompt = '''
Create a single image in ${theme.name} style with a 2:3 aspect ratio.
The image MUST include the following text rendered clearly and legibly within the illustration:
"$text"

The text should be integrated into the design as a core visual element.
Keep the text short, casual, and engaging.
Make the image fun, educational, and kid-friendly with simple, clean visuals.
Use (${theme.description}) artistic style.
''';

      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
          'responseModalities': ['TEXT', 'IMAGE']
        },
      };

      debugPrint('Sending Image Generation Request to: $endpoint');

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      debugPrint('Image generation response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        try {
          // Extract the image part
          final content = data['candidates'][0]['content'];
          final parts = content['parts'] as List;

          for (var part in parts) {
            if (part.containsKey('inlineData') &&
                part['inlineData']['mimeType'] != null &&
                part['inlineData']['mimeType'].startsWith('image/')) {
              debugPrint('Found image data in response.');
              return part['inlineData']['data']; // Return only the image data
            }
          }

          debugPrint('No image data found in response parts.');
          return null;
        } catch (e) {
          debugPrint('Error parsing image response: $e');
          return null;
        }
      } else {
        String errorMessage = 'Image Gen API Error: ${response.statusCode}';
        try {
          final errorJson = jsonDecode(response.body);
          if (errorJson['error'] != null &&
              errorJson['error']['message'] != null) {
            errorMessage = errorJson['error']['message'];
          }
        } catch (_) {}
        debugPrint('Image generation failed with error: $errorMessage');
        return null;
      }
    } catch (e) {
      debugPrint('Error during image generation network call: $e');
      return null;
    }
  }
}
