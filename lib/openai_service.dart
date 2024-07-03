
import 'dart:convert';
import 'dart:typed_data';
import 'package:stability_image_generation/stability_image_generation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

import 'api_key.dart';

class GeminiAPI {
  final StabilityAI _ai = StabilityAI();
  final ImageAIStyle imageAIStyle = ImageAIStyle.anime;

  Future<String?> yesOrNo(String prompt) async {
    // Access your API key as an environment variable (see "Set up your API key" above)
    try {
      final apiKey = GOOGLE_API_KEY;
      // For text-only input, use the gemini-pro model
      final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
      final content = [Content.text('Does this message want to generate an AI picture, image, art or anything similar? $prompt . if yes then answer yes else answer no.',)];
      final response = await model.generateContent(content);
      print(response.text);
      return response.text;
    }
    catch(e) {
      return e.toString();
    }
  }

  Future<String?> getAns(String prompt) async {
    // Access your API key as an environment variable (see "Set up your API key" above)
    try {
      final apiKey = GOOGLE_API_KEY;
      // For text-only input, use the gemini-pro model
      final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      print(response.text);
      return response.text;
    }
    catch(e) {
      return e.toString();
    }
  }

  Future<Uint8List?> genImg(String query) async {
    /// Call the generateImage method with the required parameters.
    Uint8List image = await _ai.generateImage(
      apiKey: STABILITY_AI,
      imageAIStyle: imageAIStyle,
      prompt: query,
    );
    return image;
  }

}
